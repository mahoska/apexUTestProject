/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-17-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    doInit: function (component, event, helper) {
        let gameMode = component.get("v.mode");
        let column = 0;
        //get number of column based on game mode
        if (gameMode && gameMode === 'hard') {
            column = 6;
        } else if (gameMode && gameMode === 'medium') {
            column = 4;
        } else {
            column = 3;
        }
        let blockSize = 12 / column;
        component.set("v.blockSize", blockSize);
        // build a list of 100 words
        const words = helper.getWords(column * column);
        component.set("v.words", words);
        // get win word
        const winWord = helper.getWinWord(words);
        component.set("v.winWord", winWord);
        //reset the board
        helper.resetBoard(component);
    },

    blockClickHandler: function (component, event, helper) {
        let clickCount = component.get("v.clickCount") + 1;
        //get event value
        const value = event.getParam("value");

        if (value === component.get("v.winWord")) {
            //user won
            component.set("v.result", "YOU WIN");
            //console.log("YOU WIN");
            helper.disableBoard(component);
            helper.fireResultEvent("win");
        } else if (clickCount === 3) {
            //user lose
            component.set("v.result", "YOU LOSE");
            //console.log("YOU LOSE");
            helper.disableBoard(component);
            helper.fireResultEvent("lose");
        }
        component.set("v.clickCount", clickCount);
    },

    reshuffleBoard: function (component, event, helper) {
        const words = component.get("v.words");
        const randomizeWords = helper.randomizeArray(words);
        component.set('v.words', randomizeWords);
        helper.resetBoard(component);
    }




})
