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
 * Tabcomponent for Gisviewer
 * 
 * @requires jQuery (> 1.3.2)
 * @requires commonfunctions.js
 * 
 * @param object options
 * @returns {TabComponent}
 */
B3PGissuite.defineComponent('TabComponent', {
    
    'defaultOptions': {
        useClick: false,
        useHover: true,
        tabvakClassname: 'tabvak'
    },

    constructor: function(options) {
        
        var me = this;
        me.options = jQuery.extend(me.defaultOptions, options);
        me.labelContainer = jQuery('#' + me.options.labelContainer);
        me.tabLabelContainer = me.labelContainer.find('ul');
        me.tabContainer = jQuery('#' + me.options.tabContainer);
        me.tabCollection = {};
        me.activeTab = null;
        me.lteie8 = jQuery('html').hasClass('lt-ie9');
        
        var resizeTimer = null;
        jQuery(window).bind('resize', function() {
            if (resizeTimer) clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function() {
                me.doResize();
            }, 100);
        });
    },
    
    createTab: function(tabid, label, options) {
        var tabObj = this.appendTab(this.createTabObject(tabid, label, options), options);
        if(options) {
            if(options.hasOwnProperty('contentid')) {
                var contentcontainer = jQuery('#' + options.contentid);
                tabObj.container.html(contentcontainer.html());
                if(contentcontainer.hasClass('tabvak_with_iframe')) {
                    if(this.lteie8) {
                        tabObj.container.find("iframe").each(function() {
                            this.allowTransparency = 'allowtransparency';
                        });
                    }
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
    },
    
    createTabObject: function(tabid, label, options) {
        return {
            'id': tabid,
            'label': this.createLabel(tabid, label),
            'container': this.createTabContainer(tabid, options),
            'resizableContent': options.resizableContent || false
        };
    },
    
    createTabContainer: function(tabid, options) {
        var tab = jQuery('<div></div>').css({'display': 'none'}).addClass(options.tabvakClassname || this.options.tabvakClassname).attr('id', tabid);
        return tab;
    },
    
    createLabel: function(tabid, labeltxt) {
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
    },
    
    appendTab: function(tabObj, options) {
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
    },
    
    resizeLabels: function() {
        var noOfTabs = this.getTabCount();
        var totalWidth = this.tabContainer.width();
        var tabWidth = Math.floor((totalWidth - (noOfTabs-1)) / noOfTabs);
        this.tabLabelContainer.find('a').width(tabWidth);
    },
    
    handleTabClick: function(tabid, e) {
        e.preventDefault();
        if(!this.options.useClick) return;
        this.setActive(tabid);
    },
    
    handleTabHover: function(tabid, e) {
        e.preventDefault();
        if(!this.options.useHover) return;
        this.setActive(tabid);
    },

    setVisible: function(tabid) {
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
    },
    
    setActive: function(tabid) {
        this.setVisible(tabid);
        this.activeTab = tabid;
        if(B3PGissuite.config.useCookies) {
            eraseCookie('activetab');
            createCookie('activetab', tabid, '7');
        }
    },
    
    getActiveTab: function() {
        return this.getTab(this.activeTab);
    },
    
    getTab: function(tabid) {
        if(!this.tabCollection.hasOwnProperty(tabid)) return null;
        return this.tabCollection[tabid];
    },
    
    doResize: function() {
        var tabid;
        for (tabid in this.tabCollection) {
            if(this.tabCollection.hasOwnProperty(tabid) && this.tabCollection[tabid].resizableContent) {
                this.resizeTabContents(tabid);
            }
        }
    },
    
    resizeTabContents: function(tabid) {
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
    },
    
    getTabCount: function() {
        var size = 0, key;
        for (key in this.tabCollection) {
            if (this.tabCollection.hasOwnProperty(key)) size++;
        }
        return size;
    },
    
    getTabHeight: function() {
        return this.tabContainer.height();
    },
    
    getTabWidth: function() {
        return this.tabWidth;
    }
});