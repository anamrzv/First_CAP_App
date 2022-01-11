const cds = require('@sap/cds') //require cds framework
const { Books } = cds.entities //импорт сервиса целиком

/** Service implementation for CatalogService */
module.exports = cds.service.impl(async function () {
  const { Books, Orders } = this.entities //импорт entities из сервиса 
  this.after ('READ', 'Books', each => each.stock > 111 && _addDiscount2(each,11))
  this.before ('CREATE', 'Orders', _reduceStock)
  //omit params -> for every entity
  this.before ('*', (req) => {
    console.debug('>>>>>>', req.method, req.target.name)
  })

/** Add some discount for overstocked books */
function _addDiscount2 (each,discount) {
  each.title += ` -- ${discount}% discount!`
}

/** Reduce stock of ordered books if available stock suffices */
async function _reduceStock (req) {
  const { Items: OrderItems } = req.data
  return cds.transaction(req).run (()=> OrderItems.map (order =>
    UPDATE(Books)
    .set ('stock -=', order.amount)
    .where ('ID =', order.book_ID)
    .and ('stock >=', order.amount)
  )) .then (all => all.forEach ((affectedRows,i) => {
    if (affectedRows === 0)  req.error (409,
      `${OrderItems[i].amount} exceeds stock for book #${OrderItems[i].book_ID}`
    )
  }))
}
})