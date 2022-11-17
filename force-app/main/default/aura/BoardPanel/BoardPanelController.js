/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-17-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    startGame: function (component, event, helper) {
        //access combobox
        let gameModeCombobox = component.find("gameMode");
        //access to value of combobox
        let selectedValue = gameModeCombobox.get("v.value");
        component.set("v.selectedMode", selectedValue);
        const selectedMode = component.get("v.selectedMode");

        // console.log('The start button is clicked. The game mode is: ' + selectedValue);
        if (selectedMode) {
            const boardComp = component.find("boardItem");
            boardComp.startGame();
        }
    },

    reshuffleBoard: function (component, event, helper) {
        const boardComp = component.find("boardItem");
        boardComp.reshuffleBoard();
        component.set("v.reshuffleDisabled", true);
    },

    onResultHandler: function (component, event, helper) {
        const result = event.getParam("result");
        if (result === 'win') {
            component.set('v.reshuffleDisabled', true);
            helper.showToast("YOU WIN", "Hooray!!!", "success");
        } else {
            component.set('v.reshuffleDisabled', false);
            helper.showToast("YOU LOSE", "Reshuffle the board to keep playing!!!", "error");
        }
        helper.addResultRecord(component, result);
    }
})
