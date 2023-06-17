import app from "./app";
const port = process.env.APP_PORT || 3030;

async function start() {
  app.listen(port, (): void => {
    console.info(`Server is running port: ${port}`);
  });
}

start();
