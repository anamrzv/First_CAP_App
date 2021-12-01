const appRouter = require('@sap/approuter');
const router = appRouter();

router.first.use(
    function customMiddleware(req, res, next) {
        req.headers["x-custom-host"] = process.env.TENANT_HOST;
        next();
    });

    router.beforeRequestHandler.use('/browse', function myMiddleware(req, res, next) {
        if(req.originalUrl.startsWith('/browse') ) {
            console.log("===> Got request for hints " + req.url + "by user:" , JSON.stringify(req.user) );
          }
        next();
    });

router.start();