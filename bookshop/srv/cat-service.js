const cds = require('@sap/cds') //require cds framework
const { Books } = cds.entities
const express = require('express');
const app = express();
const SapCfMailer = require('sap-cf-mailer').default;

const transporter = new SapCfMailer("MAILTRAP");

app.use(express.json());

/** Service implementation for CatalogService */
module.exports = cds.service.impl(async function () {
  const { Books, Orders, BusinessPartners } = this.entities
  const bupaSrv = await cds.connect.to('API_BUSINESS_PARTNER')

  //sending mail
  this.on('*', async (req, res) => sendMail(req, res) )


  this.after('READ', 'Books', each => each.stock > 111 && _addDiscount2(each, 11))
  this.before('CREATE', 'Orders', _reduceStock)
  //omit params -> for every entity
  this.before('*', (req) => {
    console.debug('>>>>>>', req.method, req.target.name)
  })
  this.on('READ', BusinessPartners, req => bupaSrv.tx(req).run(req.query))

  /** Block orders if business partner is blocked */
  bupaSrv.on('BusinessPartner/Changed', async msg => {
    console.log('>> Received BusinessPartner/Changed', msg.data)
    const BUSINESSPARTNER = msg.data.KEY[0].BUSINESSPARTNER
    const tx = cds.tx(msg)
    const orders = await tx.run(SELECT('ID').from(Orders).where({ createdBy: BUSINESSPARTNER, status: 'processing' }))
    if (!orders.length) return //do nothing
    const businessPartner = await bupaSrv.tx(msg).run(SELECT.one('BusinessPartnerIsBlocked').from(BusinessPartners).where({ ID: BUSINESSPARTNER }))
    if (!businessPartner || !businessPartner.BusinessPartnerIsBlocked) return
    await Promise.all(orders.map(order => tx.run(UPDATE(Orders).where(order).set({ status: 'blocked' }))))
    orders.forEach(order => this.emit('OrderBlocked', order) && console.log('>> Emitted OrderBlocked', order))
  })

  /** Add some discount for overstocked books */
  function _addDiscount2(each, discount) {
    each.title += ` -- ${discount}% discount!`
  }

  /** Reduce stock of ordered books if available stock suffices */
  async function _reduceStock(req) {
    const { Items: OrderItems } = req.data
    return cds.transaction(req).run(() => OrderItems.map(order =>
      UPDATE(Books)
        .set('stock -=', order.amount)
        .where('ID =', order.book_ID)
        .and('stock >=', order.amount)
    )).then(all => all.forEach((affectedRows, i) => {
      if (affectedRows === 0) req.error(409,
        `${OrderItems[i].amount} exceeds stock for book #${OrderItems[i].book_ID}`
      )
    }))
  }

  //has error TypeError: res.send is not a function
  async function sendMail(req, res) {
    console.debug('>>>>>> MAIL', req.method, req.target.name)
    const result = await transporter.sendMail({
      to: 'someoneimportant@sap.com',
      subject: `This is the mail subject`,
      text: `You tried to register2`
    });
    res.send(result);
  }
  
})