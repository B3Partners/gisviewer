/* 
 * Copyright (C) 2013 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Tabcontroller for Gisviewer
 * 
 * @requires jQuery (> 1.3.2)
 * @requires cookiefunctions.js
 * 
 * @param string labelContainer
 * @param string tabContainer
 * @param object options
 * @returns {TabController}
 */
function TabController(labelContainer, tabContainer, options) {
    
    this.defaultOptions = {
        width: 288,
        useClick: false,
        useHover: true
    };
    
    this.options = jQuery.extend(this.defaultOptions, options);
    this.labelContainer = jQuery('#' + labelContainer);
    this.tabLabelContainer = this.labelContainer.find('ul');
    this.tabContainer = jQuery('#' + tabContainer);
    this.tabWidth = options.width;
    this.tabCollection = {};
    this.activeTab = null;
    this.tabvakClassname = 'tabvak';
    
    this.init = function() {
        this.setupContainer();
    };
    
    this.createTab = function(tabid, label, options) {
        var tabObj = this.appendTab(this.createTabObject(tabid, label), options);
        if(options) {
            if(options.hasOwnProperty('contentid')) {
                var contentcontainer = jQuery('#' + options.contentid);
                tabObj.container.html(contentcontainer.html());
                if(contentcontainer.hasClass('tabvak_with_iframe')) {
                    tabObj.container.removeClass('tabvak').addClass('tabvak_with_iframe');
                }
                contentcontainer.remove();
            }
            if(options.hasOwnProperty('checkResize')) {
                if(tabObj.container.find('.tabvak_groot').length !== 0) {
                    tabObj.resizableContent = true;
                    this.resizeTabContents(tabid);
                }
            }
        }
        return tabObj.container.attr('id');
    };
    
    this.createTabObject = function(tabid, label) {
        return {
            'id': tabid,
            'label': this.createLabel(tabid, label),
            'container': this.createTabContainer(tabid),
            'resizableContent': false
        };
    };
    
    this.createTabContainer = function(tabid) {
        var tab = jQuery('<div></div>').css({'display': 'none'}).addClass(this.tabvakClassname).attr('id', tabid);
        return tab;
    };
    
    this.createLabel = function(tabid, labeltxt) {
        var me = this;
        var label = jQuery('<li></li>');
        
        label
            .bind('click', function(e) {
                me.handleTabClick(tabid, e);
            })
            .bind('mouseover', function(e) {
                me.handleTabHover(tabid, e);
            })
            .append('<a href="#">' + labeltxt + '</a>');

        return label;
    };
    
    this.appendTab = function(tabObj, options) {
        if(options && options.hasOwnProperty('containerid')) {
            $j("#" + options.containerid).append(tabObj.container.show());
            return tabObj;
        } else {
            this.tabCollection[tabObj.id] = tabObj;
            this.tabLabelContainer.append(tabObj.label);
            this.tabContainer.append(tabObj.container);
            this.resizeLabels();
            return this.tabCollection[tabObj.id];
        }
    };
    
    this.resizeLabels = function() {
        var noOfTabs = this.getTabCount();
        var tabWidth = Math.floor((this.tabWidth - (noOfTabs-1)) / noOfTabs);
        this.tabLabelContainer.find('a').width(tabWidth);
    };
    
    this.setupContainer = function() {
        var newCss = { 'width': this.tabWidth + 'px' };
        if(this.tabWidth === 0) newCss.visibility = 'hidden';
        this.labelContainer.css(newCss);
        this.tabLabelContainer.css(newCss);
        this.tabContainer.css(newCss);
    };
    
    this.handleTabClick = function(tabid, e) {
        e.preventDefault();
        if(!this.options.useClick) return;
        this.setActive(tabid);
    };
    
    this.handleTabHover = function(tabid, e) {
        e.preventDefault();
        if(!this.options.useHover) return;
        this.setActive(tabid);
    };

    this.setVisible = function(tabid) {
        var currentTab = this.getActiveTab();
        if(currentTab !== null) {
            currentTab.container.hide();
            currentTab.label.removeClass('activelink');
        }
        var tabObj = this.getTab(tabid);
        if(tabObj !== null) {
            tabObj.container.show();
            tabObj.label.addClass('activelink');
            if(tabObj.resizableContent) {
                this.resizeTabContents(tabid);
            }
        }
    };
    
    this.setActive = function(tabid) {
        this.setVisible(tabid);
        this.activeTab = tabid;
        eraseCookie('activetab');
        createCookie('activetab', tabid, '7');
    };
    
    this.getActiveTab = function() {
        return this.getTab(this.activeTab);
    };
    
    this.getTab = function(tabid) {
        if(!this.tabCollection.hasOwnProperty(tabid)) return null;
        return this.tabCollection[tabid];
    };
    
    this.doResize = function() {
        var tabid;
        for (tabid in this.tabCollection) {
            if(this.tabCollection.hasOwnProperty(tabid) && this.tabCollection[tabid].resizableContent) {
                this.resizeTabContents(tabid);
            }
        }
    };
    
    this.resizeTabContents = function(tabid) {
        var tabObj = this.tabCollection[tabid];
        var tabContainer = tabObj.container;
        var contentHeight = 0;
        var tabChilds = tabContainer.children().not('.tabvak_groot');
        if(tabChilds.length === 1 && tabChilds.is('form')) {
            tabChilds = tabChilds.children().not('.tabvak_groot');
        }
        tabChilds.each(function() {
            contentHeight += jQuery(this).outerHeight(true);
        });
        var elementHeight = (this.getTabHeight() - 30) - contentHeight;
        if(elementHeight > 0) { 
            tabContainer.find('.tabvak_groot').height(elementHeight);
        }
    };
    
    this.getTabCount = function() {
        var size = 0, key;
        for (key in this.tabCollection) {
            if (this.tabCollection.hasOwnProperty(key)) size++;
        }
        return size;
    };
    
    this.getTabHeight = function() {
        return this.tabContainer.height();
    };
    
    this.getTabWidth = function() {
        return this.tabWidth;
    };
    
    this.init();
    
    var me = this;
    var resizeTimer = null;
    jQuery(window).bind('resize', function() {
        if (resizeTimer) clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            me.doResize();
        }, 100);
    });
}