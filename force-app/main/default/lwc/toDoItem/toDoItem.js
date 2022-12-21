/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-21-2022
 * @last modified by  : Anna Makhovskaya
**/
import { LightningElement, api } from 'lwc';
import updateTodo from "@salesforce/apex/toDoController.updateTodo";
import deleteTodo from "@salesforce/apex/toDoController.deleteTodo";

export default class ToDoItem extends LightningElement {

    @api todoId;
    @api todoName;
    @api done = false;


    get containerClass() {
        return this.done ? "todo completed" : "todo upcoming"
    }

    get iconName() {
        return this.done ? "utility:check" : "utility:add";
    }

    updateHandler() {
        const todo = {
            todoId: this.todoId,
            todoName: this.todoName,
            done: !this.done
        };

        updateTodo({ payload: JSON.stringify(todo) }).then(result => {
            console.log('Item updated successfully');
            const updateEvent = new CustomEvent('update');
            this.dispatchEvent(updateEvent);
        }).catch(error => {
            console.error('Error in update ' + error);
        });
    }

    deleteHandler() {
        deleteTodo({ todoId: this.todoId }).then(result => {
            console.log('Item deleted successfully');
            const deleteEvent = new CustomEvent('update');
            this.dispatchEvent(deleteEvent);
        }).catch(error => {
            console.error('Error in delete ' + error);
        });
    }
}