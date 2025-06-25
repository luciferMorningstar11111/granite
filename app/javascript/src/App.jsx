import React from "react";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
import { ToastContainer } from "react-toastify";

import { CreateTask, ShowTask,EditTask } from "components/Tasks";
import Dashboard from "components/Dashboard";

const App = () => {
  return (
    <Router>
      <ToastContainer />
      <Switch>
        <Route exact path="/tasks/:slug/edit" component={EditTask} />
        <Route exact path="/tasks/:slug/show" component={ShowTask} />
        <Route exact path="/tasks/create" component={CreateTask} />
        <Route exact path="/dashboard" component={Dashboard} />
      </Switch>
    </Router>
  );
};

export default App;
