import { observer } from "mobx-react-lite";
import { motion } from "framer-motion";
import { useStore } from "./store/store";

const TodoList = () => {
  const { todoStore } = useStore();

  return (
    <motion.li
      whileHover={{
        scale: 0.9,
        transition: { type: "spring", duration: 0.2 },
      }}
      exit={{
        x: "-60vw",
        scale: [1, 0],
        transition: { duration: 0.5 },
        backgroundColor: "rgba(255,0,0,1)",
      }}
      className="displaytodos"
    >
      {todoStore.list.map((l) => (
    

        <h3 className="card" key={l.id}>
          {l.title}
        </h3>
        
      ))}
      
    </motion.li>
  );
};

export default observer(TodoList);