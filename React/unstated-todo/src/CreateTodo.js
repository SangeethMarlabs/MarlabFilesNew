import React from 'react'
import { Subscribe } from 'unstated'
import TodoContainer from './containers/todoContainer'

const CreateTodo = () => {
  return (
    <div>
      <Subscribe to={[TodoContainer]}>
        {todostate =>
          <div>
            <form onSubmit={todostate.handleAddTodo}>
              <input
                type="text"
                value={todostate.state.todo}
                onChange={todostate.handleInputChange}
              />
              <button>Submit</button>
            </form>
          </div>
        }
      </Subscribe>
    </div>
    );
}

export default CreateTodo