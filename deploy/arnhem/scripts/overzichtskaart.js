/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function flamingo_b_showOverzicht_onEvent(id,event) {
    if (event["down"]) {
        webMapController.getMap().getFrameworkMap().callMethod("overviewwindow", 'setVisible', true);
    }
}