/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-19-2022
 * @last modified by  : Anna Makhovskaya
**/
import { LightningElement, api } from 'lwc';

export default class ToDoItem extends LightningElement {

    @api todoId;
    @api todoName;
    @api done = false;
}