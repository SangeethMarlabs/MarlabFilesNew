import React from 'react';
import { Subscribe } from 'unstated';

import TodoContainer from './containers/todoContainer'

const Todos = () => (
  <ul>
    <Subscribe to={[TodoContainer]}>
      {todostate =>
        todostate.state.todos.map(todo => (
          <li key={todo}>
            {todo} <button onClick={() => todostate.handleDeleteTodo(todo)}>X</button>
          </li>
        ))
      }
    </Subscribe>
  </ul>
);

export default Todos

