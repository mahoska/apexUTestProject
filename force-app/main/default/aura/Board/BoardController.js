/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-15-2022
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
        console.log("Words: " + words);
        // get win word
        const winWord = helper.getWinWord(words);
        component.set("v.winWord", winWord);
        console.log("Win word: " + helper.getWinWord(words));
    }
})
