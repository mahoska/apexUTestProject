/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-15-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    startGame: function (component, event, helper) {
        //access combobox
        let gameModeCombobox = component.find("gameMode");
        //access to value of combobox
        let selectedValue = gameModeCombobox.get("v.value");
        component.set("v.selectedMode", selectedValue);
        console.log('The start button is clicked. The game mode is: ' + selectedValue);
    },

    reshuffleBoard: function (component, event, helper) {
        console.log('The reshuffleBoard button is click');
    }
})
