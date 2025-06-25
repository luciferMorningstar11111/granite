import React from "react";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
import CreateTask from "components/Tasks/Create";
import Dashboard from "components/Dashboard";
const App = () => {
  return (
    <Router>
      <Switch>
        <Route exact path="/" render={() => <div><h1>home</h1></div>} />
        <Route exact path="/tasks/create" component={CreateTask} />
        <Route exact path="/dashboard" component={Dashboard} />
      </Switch>
    </Router>
  );
};

export default App;
