import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import HomePage from './components/HomePage';
import UserDetailsPage from './components/UserDetailsPage';

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/" component={HomePage} />
        <Route path="/user/:username" component={UserDetailsPage} />
      </Switch>
    </Router>
  );
}

export default App;