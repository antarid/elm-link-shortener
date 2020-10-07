import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import { showLink, hideLink } from './mini-app';

const app = Elm.Main.init({
  node: document.getElementById('root'),
});

app.ports.sendMessage.subscribe(function (message) {
  const [command, data] = JSON.parse(message);
  switch (command) {
    case 'showLink':
      return showLink(data);
    case 'hideLink':
      return hideLink();

    default:
      throw new Error('Unknown command');
  }
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
