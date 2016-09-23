B3PGissuite.defineComponent('Admindata', {

    /* vars */
    rootBronContainer: true,
    idcounter: 1,
    timeout: 30000,
    loop: 0,
    currentThemaid: null,
    currentKeyName: null,
    currentKeyValue: null,
    currentAttributeName: null,
    currentEenheid: null,
    isOpen: false,
    currentEl: null,
    options: {
        onlyFeaturesInGeom: '',
        bookmarkAppcode: '',
        plusicon: '',
        minusicon: '',
        infoicon: '',
        urlicon: '',
        flagicon: '',
        wandicon: '',
        loadingicon: '',
        pencil: '',
        pdficon: '',
        docicon: '',
        csvexporticon: '',
        infoexporticon: '',
        googleIcon: '',
        noResultsHeader: '',
        noResultsTekst: '',
        hideEmptyResults: true
    },

    constructor: function Admindata(options) {
        this.init(options);
    },

    init: function(options) {
        this.options = jQuery.extend(this.options, options);
    },

    editFeature: function(ggbId, attrName, attrVal) {
        this.getParent().B3PGissuite.viewercommons.drawFeature(ggbId, attrName, attrVal);
    },

    popUp: function(link, title, width, heigth) {
        var pu = this.getParent().B3PGissuite.viewercommons.popUp(link, title, width, heigth);
        if (window.focus && pu) {
            pu.focus();
        }
    },

    getParent: function() {
        return B3PGissuite.commons.getParent({parentOnly: true});
    },

    uniqueId: function(id) {
        return id + this.idcounter++;
    },

    writeFeatureInfoData: function(obj) {
        var tableData = "";
        for (var layer in obj) {
            tableData += "<table class=\"aanvullende_info_table\" >";
            for (var feature in obj[layer]) {
                tableData += "    <tr class=\"topRow\">";
                tableData += "        <th colspan=\"2\" class=\"aanvullende_info_td\">&nbsp;";
                tableData += layer;
                tableData += "        </th>";
                tableData += "    </tr>";
                var tellerAtt = 0;
                for (var attribute in obj[layer][feature]) {
                    if (tellerAtt % 2 === 0) {
                        tableData += "    <tr>";
                    } else {
                        tableData += "    <tr class=\"aanvullende_info_alternateTr\">";
                    }
                    tellerAtt++;
                    tableData += "        <td>" + attribute + "</td>";
                    tableData += "        <td>" + obj[layer][feature][attribute] + "</td>";
                    tableData += "    </tr>";
                }
                tableData += "    <tr><td> </td><td> </td></tr>";
            }
            tableData += "</table>";
        }
        if (tableData.length > 0) {
            this.removeWaiting();
        }
        document.getElementById('getFeatureInfo').innerHTML = tableData;
    },

    removeWaiting: function() {
        if(document.getElementById("content_style") === null) return;
        // wachtmelding weghalen
        document.getElementById("content_style").style.display = "none";
    },

    writeNoResults: function() {
        var me = this;
        window.setTimeout(function() {
            me.writeNoResultsHtml();
        }, this.timeout);
    },

    writeNoResultsHtml: function() {
        if(document.getElementById("content_style") === null) return;
        var tableData = "";
        tableData += "<table class=\"kolomtabel\">";
        tableData += "<tr>";
        tableData += "<td valign=\"top\">";
        tableData += "<div id=\"inleiding\" class=\"loadingMessage\">";
        tableData += "<h2>" + this.options.noResultsHeader + "</h2>";
        tableData += "<p>" + this.options.noResultsTekst + "</p>";
        tableData += "</div>";
        tableData += "</td>";
        tableData += "</tr>";
        tableData += "</table>";
        document.getElementById('content_style').innerHTML = tableData;
        document.getElementById('content_style').style.display = 'block';
    },

    addGegevensbron: function(opts) {
        var me = this;
        // optellen aantal gegevensbronnen
        this.loop++;
        // haal gegevens op van gegevensbron                    
        JCollectAdmindata.fillGegevensBronBean(opts.bean.id, opts.bean.themaId, opts.bean.wkt, opts.bean.cql, false, opts.htmlId, this.options.bookmarkAppcode, function(gegevensbron) {
            me.handleGetGegevensBron(gegevensbron);
        });
    },

    addGebiedenbron: function(opts) {
        var me = this;
        JCollectAdmindata.fillGegevensBronBean(opts.bean.id, opts.bean.themaId, opts.bean.wkt, opts.bean.cql, false, opts.htmlId, this.options.bookmarkAppcode, function(gegevensbron) {
            me.handleGebiedenBron(gegevensbron);
        });
    },

    handleGetGegevensBron: function(gegevensbron) {
        if(gegevensbron === null) return;
        var me = this;
        // aftellen verwerkte gegevensbron
        this.loop--;
        if (!gegevensbron) {
            if (this.loop <= 0) {
                // geen enkele gegevensbron was gevuld!
                this.writeNoResults();
            }
            return;
        }
        //minstens 1 gegevensbron was gevuld, nooit writeNoResults schrijven
        var layout = gegevensbron.layout;
        if (layout == "admindata2") {
            this.handleGetGegevensBronSimpleHorizontal(gegevensbron);
        } else if (layout == "admindata3") {
            this.handleGetGegevensBronSimpleVertical(gegevensbron);
        } else if (layout.search("all_vertical") !== -1) {
            this.handleGetGegevensAllVertical(gegevensbron, layout.replace("all_vertical_", ""));
        } else if (layout == "admindata1a") {
            this.handleGetGegevensBronMultiVertical(gegevensbron);
        } else {
            this.handleGetGegevensBronMulti(gegevensbron);
        }

        $j("#adminDataWrapper > .bronContainer").addClass("rootBronContainer");
        
        if (this.loop <= 0) {
            var visibleBronContainers = $j("#adminDataWrapper > .bronContainer:visible, #adminDataWrapper > #tabContainer > .bronContainer:visible");
            if(visibleBronContainers.length === 0) {
                this.writeNoResultsHtml();
            }
        }
        
        if (B3PGissuite.commons.getIEVersion() <= 7 && B3PGissuite.commons.getIEVersion() !== -1) {
            this.resizeWidthIE();
        }
    },

    getBronContainer: function(htmlId, gegevensbron, classes) {
        return $j('<div></div>').attr({
            "id": this.uniqueId("bronContainer" + htmlId + gegevensbron.id),
            "class": classes
        });
    },

    addRows: function(opts) {
        var seperateRows = (opts.hasOwnProperty('seperateRows') && opts.seperateRows);
        var cellOnly = (opts.hasOwnProperty('cellOnly') && opts.cellOnly);
        var me = this;
        $j.each(opts.record.values, function(index2, waarde) {
            if(!cellOnly) {
                var tr = $j('<tr></tr>');
                tr.append(me.createTableTh(opts.gegevensbron.labels[index2], opts.gegevensbron));
                var td = me.createTableTd(waarde, opts.gegevensbron, opts.record);
                if(seperateRows) {
                    opts.parent.append(tr);
                    opts.parent.append($j('<tr></tr>').append(td));
                } else {
                    tr.append(td);
                    opts.parent.append(tr);
                }
            } else {
                opts.parent.append(me.createTableTd(waarde, opts.gegevensbron, opts.record));
            }
        });
    },

    handleGebiedenBron: function(gegevensbron) {
        if(gegevensbron === null) return;
        var me = this,
            htmlId = gegevensbron.parentHtmlId;

        // Create container
        var bronContainer = this.getBronContainer(htmlId, gegevensbron, "gebiedenContainer");

        // Create table content    
        if (gegevensbron.records) {
            var title = $j('<div></div>').addClass('gebiedenTitle').html(gegevensbron.title);
            bronContainer.append(title);

            $j.each(gegevensbron.records, function(index, record) {
                // Create content table
                var bronContent = $j('<div></div>').attr({
                    "id": me.uniqueId("bronContent" + htmlId + gegevensbron.id + "_" + record.id),
                    "class": "bronContent"
                });
                var bronTable = $j('<table></table>');
                var bronTableBody = $j('<tbody></tbody>');

                me.addRows({
                    'gegevensbron': gegevensbron,
                    'record': record,
                    'parent': bronTableBody
                });

                // Append all to DOM tree
                bronContent.append(bronTable.append(bronTableBody));
                bronContainer.append(bronContent);
            });
        }

        $j('#' + htmlId).append(bronContainer);
    },

    resizeWidthIE: function() {
        var totalwidth = $j("#adminDataWrapper").outerWidth(true);
        $j("#adminDataWrapper > .rootBronContainer").each(function() {
            if ($j(this).outerWidth(true) < totalwidth)
                $j(this).width(totalwidth);
        });
    },

    handleGetGegevensBronSimpleVertical: function(gegevensbron) {
        var me = this,
            htmlId = gegevensbron.parentHtmlId;

        // Create container
        var bronContainer = this.getBronContainer(htmlId, gegevensbron, "bronContainer");
        if (this.rootBronContainer) {
            bronContainer.addClass("rootBronContainer");
            this.rootBronContainer = false;
        }

        // csv, info en pdf export boven alle records tonen
        var bronCaption = this.createBronCaption(gegevensbron, true, null);
        bronContainer.append(bronCaption);

        /* Only auto open pop-up when one record is found and one objectdata field 
         * is configured in basisregel */
        if (gegevensbron.records && gegevensbron.records.length == 1) {
            var url;
            var popupNumber = this.getParent().B3PGissuite.config.autoRedirect;
            if (gegevensbron.records[0].values 
                    && gegevensbron.records[0].values.length == popupNumber) {
                if (gegevensbron.records[0].values[0].value) {
                    url = gegevensbron.records[0].values[0].value;
                }

                if (gegevensbron.records[0].values[0].valueList) {
                    url = gegevensbron.records[0].values[0].valueList;
                }

                me.popUp(url, 'externe_link', 800, 600);
            }
        }

        // Create table content    
        if (gegevensbron.records) {
            $j.each(gegevensbron.records, function(index, record) {
                // Create content table
                var bronContent = $j('<div></div>').attr({
                    "id": me.uniqueId("bronContent" + htmlId + gegevensbron.id + "_" + record.id),
                    "class": "bronContent"
                });
                var bronTable = $j('<table></table>');
                var bronTableBody = $j('<tbody></tbody>');

                me.addRows({
                    'gegevensbron': gegevensbron,
                    'record': record,
                    'parent': bronTableBody
                });

                // Append all to DOM tree
                bronContent.append(bronTable.append(bronTableBody));
                bronContainer.append(bronContent);
            });
        } else {
            if(this.options.hideEmptyResults) {
                bronContainer.hide();
            } else {
                bronContainer.append(this.createEmptyBronContent(htmlId, gegevensbron.id));
            }
        }

        this.removeWaiting();
        $j('#' + htmlId).append(bronContainer);
    },

    handleGetGegevensBronMultiVertical: function(gegevensbron) {
        var me = this,
            htmlId = gegevensbron.parentHtmlId;

        // Create container
        var bronContainer = this.getBronContainer(htmlId, gegevensbron, "bronContainer");
        if (this.rootBronContainer) {
            bronContainer.addClass("rootBronContainer");
            this.rootBronContainer = false;
        }

        // csv, info en pdf export boven alle records tonen
        var bronCaption = this.createBronCaption(gegevensbron, false, null);
        bronContainer.append(bronCaption);

        /* Only auto open pop-up when one record is found and one objectdata field 
         * is configured in basisregel */
        if (gegevensbron.records && gegevensbron.records.length == 1) {
            var url;
            var popupNumber = this.getParent().B3PGissuite.config.autoRedirect;
            if (gegevensbron.records[0].values 
                    && gegevensbron.records[0].values.length == popupNumber) {
                if (gegevensbron.records[0].values[0].value) {
                    url = gegevensbron.records[0].values[0].value;
                }

                if (gegevensbron.records[0].values[0].valueList) {
                    url = gegevensbron.records[0].values[0].valueList;
                }

                me.popUp(url, 'externe_link', 800, 600);
            }
        }

        // Create table content    
        if (gegevensbron.records) {
            $j.each(gegevensbron.records, function(index, record) {
                // Create content table
                var bronContent = $j('<div></div>').attr({
                    "id": me.uniqueId("bronContent" + htmlId + gegevensbron.id + "_" + record.id),
                    "class": "bronContent"
                });
                var bronTable = $j('<table></table>');
                var bronTableBody = $j('<tbody></tbody>');

                me.addRows({
                    'gegevensbron': gegevensbron,
                    'record': record,
                    'parent': bronTableBody
                });

                // Append all to DOM tree
                bronContent.append(bronTable.append(bronTableBody));
                bronContainer.append(bronContent);
            });
        } else {
            if(this.options.hideEmptyResults) {
                bronContainer.hide();
            } else {
                bronContainer.append(this.createEmptyBronContent(htmlId, gegevensbron.id));
            }
        }

        this.removeWaiting();
        $j('#' + htmlId).append(bronContainer);
    },

    handleGetGegevensAllVertical: function(gegevensbron, tab) {
        var me = this,
            htmlId = gegevensbron.parentHtmlId;

        var bronContainer = this.getBronContainer(htmlId, gegevensbron, "bronContainer tabbedContainer " + tab);
        var tabFieldId = "tabField_" + tab;
        var tabField = $j('<div></div>').attr({
            "id": tabFieldId,
            "class": "tabField"
        }).click(function() {
            me.switchDataTab($j(this));
        }).html(tab);

        if (tab == 'tab1') {
            tabField.html('1');
        } else if (tab == 'tab2') {
            tabField.html('2');
        } else if (tab == 'tab3') {
            tabField.html('3');
        } else if (tab == 'tab4') {
            tabField.html('4');
        } else if (tab == 'tab5') {
            tabField.html('5');
        }

        // Create table content
        if (gegevensbron.records) {
            $j.each(gegevensbron.records, function(index, record) {
                // Create caption
                var bronCaption = me.createBronCaption(gegevensbron, true, index + 1);
                // bronCaption.append(tab);
                // Create content table
                var bronContent = $j('<div></div>').attr({
                    "id": me.uniqueId("bronContent" + htmlId + gegevensbron.id + "_" + record.id),
                    "class": "bronContent"
                });
                var bronTable = $j('<table></table>');
                var bronTableBody = $j('<tbody></tbody>');

                me.addRows({
                    'gegevensbron': gegevensbron,
                    'record': record,
                    'parent': bronTableBody,
                    'seperateRows': true
                });

                // Append all to DOM tree
                bronContent.append(bronTable.append(bronTableBody));
                bronContainer.append(bronCaption.css({
                    "color": "#000000",
                    "background-color": "#ffffff"
                })).append(bronContent);
            });
        }

        this.removeWaiting();

        var bronContainerOrder = {};
        if (gegevensbron.records) {
            if ($j('#' + htmlId).find("#tabHeader").length != 1) {
                var tabHeader = $j('<div></div>').attr({
                    "id": "tabHeader",
                    "class": "tabHeader",
                    "style": "width: 100%; height: 20px;"
                });
                $j('#' + htmlId).append(tabHeader);
                $j('#' + htmlId + " > #tabHeader").append(tabField.addClass("tabFieldActive"));
            } else {
                if ($j('#' + htmlId + " > #tabHeader").find("#" + tabField.attr("id")).length != 1) {
                    $j('#' + htmlId + " > #tabHeader").append(tabField);
                }
            }
            bronContainerOrder[bronContainer.attr("id")] = gegevensbron.order;

            if ($j('#' + htmlId).find("#tabContainer").length != 1)
            {
                var tabContainer = $j('<div></div>').attr({
                    "id": "tabContainer",
                    "class": "tabContainer"
                });
                $j('#' + htmlId).append(tabContainer);
                tabContainer.append(bronContainer);
            } else {
                if (!$j("#" + tabFieldId).hasClass("tabFieldActive"))
                    bronContainer.css("display", "none");
                var diff = 0;
                var beforeElement = null;
                if (gegevensbron.order !== null) {
                    $j.each($j('#' + htmlId + " > #tabContainer").children(), function(index, domElement) {
                        var elemOrder = bronContainerOrder[domElement.id];
                        if (elemOrder > gegevensbron.order && (diff === 0 || diff > elemOrder - gegevensbron.order)) {
                            beforeElement = domElement;
                            diff = elemOrder - gegevensbron.order;
                        }
                    });
                }
                if (beforeElement !== null) {
                    bronContainer.insertBefore(beforeElement);
                } else {
                    $j('#' + htmlId + " > #tabContainer").append(bronContainer);
                }
            }
        }
    },

    switchDataTab: function($tablink) {
        var $tabContainer = $tablink.parent().next();
        $tablink.parent().find(".tabFieldActive").removeClass("tabFieldActive");
        $tabContainer.find(".tabbedContainer").hide();
        $tabContainer.find("." + $tablink.attr("id").replace("tabField_", "")).show();
        $tablink.addClass("tabFieldActive");
    },

    handleGetGegevensBronSimpleHorizontal: function(gegevensbron) {
        var me = this,
            htmlId = gegevensbron.parentHtmlId;

        // Create container
        var bronContainer = this.getBronContainer(htmlId, gegevensbron, "bronContainer");
        if (this.rootBronContainer) {
            bronContainer.addClass("rootBronContainer");
            this.rootBronContainer = false;
        }

        // csv, info en pdf export boven alle records tonen
        var bronCaption = this.createBronCaption(gegevensbron, true, null);
        bronContainer.append(bronCaption);

        // Create content table
        var bronContent = $j('<div></div>').attr({
            "id": this.uniqueId("bronContent" + htmlId + gegevensbron.id),
            "class": "bronContent"
        });
        var bronTable = $j('<table></table>');
        var bronTableHead = $j('<thead></thead>');
        var bronTableBody = $j('<tbody></tbody>');

        // Create table heading
        if (gegevensbron.records) {
            var trHead = this.createTableHead(gegevensbron.labels, true);
            bronTableHead.append(trHead);
        }

        // Create table content
        if (!gegevensbron.records) {
            if(this.options.hideEmptyResults) {
                bronContainer.hide();
            } else {
                var size = 1;
                if (gegevensbron.labels) {
                    size = gegevensbron.labels.length;
                }
                var tr = this.createEmptyRow(size);
                bronTableBody.append(tr);
            }
        } else {
            $j.each(gegevensbron.records, function(index, record) {
                var tr = $j('<tr></tr>');
                me.addRows({
                    'gegevensbron': gegevensbron,
                    'record': record,
                    'parent': tr,
                    'cellOnly': true
                });
                bronTableBody.append(tr);
            });
        }

        this.removeWaiting();
        // Append all to DOM tree
        bronContent.append(bronTable.append(bronTableHead).append(bronTableBody));
        bronContainer.append(bronContent);

        $j('#' + htmlId).append(bronContainer);
    },

    handleGetGegevensBronMulti: function(gegevensbron) {
        var htmlId = gegevensbron.parentHtmlId;
        var me = this;

        // Create container
        var bronContainer = this.getBronContainer(htmlId, gegevensbron, "bronContainer");

        if (this.rootBronContainer) {
            bronContainer.addClass("rootBronContainer");
            this.rootBronContainer = false;
        }

        // Create caption
        var bronCaption = this.createBronCaption(gegevensbron, false, null);

        // Create content table
        var bronContent = $j('<div></div>').attr({
            "id": this.uniqueId("bronContent" + htmlId + gegevensbron.id),
            "class": "bronContent bronContentOpen"
        });
        var bronTable = $j('<table></table>');
        var bronTableHead = $j('<thead></thead>');
        var bronTableBody = $j('<tbody></tbody>');

        // Create table heading
        if (gegevensbron.editable && this.getParent().B3PGissuite.config.showEditTool) {
            var bewerk = {
                commando: null,
                eenheid: null,
                id: -1,
                kolomBreedte: 0,
                kolomNaam: "bewerk",
                label: "Bewerk feature",
                type: "TYPE_DATA"
            };
            gegevensbron.labels.push(bewerk);
        }

        if (gegevensbron.records) {
            var trHead = this.createTableHead(gegevensbron.labels, false);
            bronTableHead.append(trHead);
        }

        /* Only auto open pop-up when one record is found and the number of 
         * objectdata fields equals configured number  */
        if (gegevensbron.records && gegevensbron.records.length == 1) {
            var url;
            var popupNumber = this.getParent().B3PGissuite.config.autoRedirect;
            if (gegevensbron.records[0].values 
                    && gegevensbron.records[0].values.length == popupNumber) {
                if (gegevensbron.records[0].values[0].value) {
                    url = gegevensbron.records[0].values[0].value;
                }

                if (gegevensbron.records[0].values[0].valueList) {
                    url = gegevensbron.records[0].values[0].valueList;
                }

                me.popUp(url, 'externe_link', 800, 600);
            }
        }

        // Create table content
        if (!gegevensbron.records) {
            if(this.options.hideEmptyResults) {
                bronContainer.hide();
            } else {
                var size = 1;
                if (gegevensbron.labels) {
                    size = gegevensbron.labels.length;
                }
                var tr = this.createEmptyRow(size, htmlId !== "adminDataWrapper");
                bronTableBody.append(tr);
            }
        } else {
            $j.each(gegevensbron.records, function(index, record) {
                var tr = $j('<tr></tr>');
                var volgnr = $j('<td></td>').css({
                    "width": "50px"
                });

                if (record.showMagicWand) {
                    var icon = $j('<img src="' + me.options.wandicon + '" alt="Selecteer object in kaart" title="Selecteer object in kaart" />')
                            .click(function() {
                        me.editFeature(gegevensbron.id, gegevensbron.adminPk, record.id);
                    });
                    volgnr.append(icon);
                }

                volgnr.append(" ");
                volgnr.append(index + 1);

                tr.append(volgnr);
                me.addRows({
                    'gegevensbron': gegevensbron,
                    'record': record,
                    'parent': tr,
                    'cellOnly': true
                });

                var editTd = $j('<td></td>').css({
                    "width": "50px"
                });

                if (gegevensbron.editable && me.getParent().B3PGissuite.config.showEditTool) {
                    var icon = $j('<img src="' + me.options.pencil + '" alt="Edit object" title="Edit object" />')
                            .click(function() {
                        var ec = me.getParent().B3PGissuite.vars.editComponent;
                        ec.edit(record, gegevensbron.id);
                    });
                    editTd.append(icon);
                }
                tr.append(editTd);

                bronTableBody.append(tr);
                // Check if there are childs
                if (record.childs != null && record.childs.length > 0) {
                    $j.each(record.childs, function(index2, child) {
                        var childDivId = me.uniqueId('bronChild' + gegevensbron.id + '_' + me.fixId(record.id) + '_' + me.fixId(child.id));
                        var childTr = $j('<tr></tr>');
                        var toggleIcon = $j('<img src="' + me.options.plusicon + '" alt="Openklappen" title="Openklappen" />')
                                .click(function() {
                            var childWkt = child.wkt;
                            if (!me.options.onlyFeaturesInGeom) {
                                childWkt = null;
                            }
                            var childLoaded = me.loadChild(childDivId, child.id, childWkt, child.cql);
                            if (!childLoaded)
                                me.toggleBron($j(this));
                        });
                        var collapse = $j('<td></td>').css({
                            "width": "50px"
                        });
                        childTr.append(collapse);
                        var childTd = $j('<td></td>').attr({
                            "colSpan": record.values.length
                        });
                        var childCaption = $j('<div></div>').attr({
                            "id": "childCaption" + childDivId,
                            "class": "childCaption"
                        });
                        childCaption
                                .append(toggleIcon)
                                .append(' ' + child.title);
                        if (child.aantalRecords > 1) {
                            childCaption.append(' (' + child.aantalRecords + ')');
                        }
                        var childDiv = $j('<div></div>').attr({
                            "id": childDivId,
                            "class": "bronChild bronChildEmpty"
                        });
                        var loadingIcon = $j('<img src="' + me.options.loadingicon + '" alt="Loading" title="Loading" />')
                        var childLoading = $j('<div></div>').attr({
                            "id": "childLoading" + childDivId,
                            "class": "childLoading"
                        })
                                .append(loadingIcon)
                                .hide();
                        childTd
                                .append(childCaption)
                                .append(childLoading)
                                .append(childDiv);
                        childTr.append(childTd);
                        bronTableBody.append(childTr);
                        // toggleIcon.click();
                    });
                }
            });
        }

        this.removeWaiting();

        // Append all to DOM tree
        bronContent.append(bronTable.append(bronTableHead).append(bronTableBody));
        bronContainer
                .append(bronCaption)
                .append(bronContent);
        $j('#' + htmlId).append(bronContainer);

        // child loading weghalen indien aanwezig
        $j('#' + htmlId).siblings('.childLoading').hide();

    // alle childs pre-loaden
    // $j('.childCaption', bronContainer).find('img').click();
    },

    loadChild: function(bronContentId, beanId, wkt, beanCql) {
        var me = this, $bronContentDiv = $j('#' + bronContentId);

        if ($bronContentDiv.hasClass("bronChildEmpty"))
        {
            JCollectAdmindata.fillGegevensBronBean(beanId, 0, wkt, beanCql, false, bronContentId, this.options.bookmarkAppcode, function(gegevensbron) {
                me.handleGetGegevensBron(gegevensbron);
            });
            $bronContentDiv.removeClass("bronChildEmpty").addClass("bronContentClosed");
            $j("#childCaption" + bronContentId).hide();
            $j('#childLoading' + bronContentId).show();
            window.setTimeout(function() {
                $j('#childLoading' + bronContentId).hide();
            }, this.timeout);

            return true;
        }

        return false;
    },

    toggleBron: function(toggleIcon) {
        // toggleIcon = plus/min icon clicked
        // Test first if clicked icon is part of childCaption (-> hide child caption, show child)
        if (toggleIcon.parent().hasClass("childCaption")) {
            var $childBron = toggleIcon.parent().siblings(".bronChild").children();
            $childBron.children(".bronCaption").show();
            $childBron.children(".bronContent").show().removeClass("bronContentClosed").addClass("bronContentOpen");
            toggleIcon.parent().hide();
        } else {
            var $bronContent = toggleIcon.parent().siblings('.bronContent');
            // Check if clicked icon is part of rootElement
            if ($bronContent.parent().hasClass("rootBronContainer")) {
                if ($bronContent.hasClass("bronContentOpen")) {
                    $bronContent.hide().removeClass("bronContentOpen").addClass("bronContentClosed");
                    toggleIcon.attr("src", this.options.plusicon);
                } else {
                    $bronContent.show().removeClass("bronContentClosed").addClass("bronContentOpen");
                    toggleIcon.attr("src", this.options.minusicon);
                }
                // It is a child element (-> Hide child, show child caption)
            } else {
                if ($bronContent.hasClass("bronContentOpen")) {
                    $bronContent.parent().parent().siblings('.childCaption').show();
                    $bronContent.hide().removeClass("bronContentOpen").addClass("bronContentClosed");
                    $bronContent.siblings(".bronCaption").hide();
                }
            }
        }
    },

    fixId: function(myid) {
        var newId = "";
        if (typeof myid === 'string') {
            newId = myid.replace(/(:|\.|\s)/g, '_');
        }
        return newId;
    },

    createBronCaption: function(gegevensbron, simple, index) {
        var createSimple = false, me = this;
        if (simple) {
            createSimple = true;
        }

        var htmlId = gegevensbron.parentHtmlId;
        var title = gegevensbron.title;
        if (index) {
            title += " " + index;
        } else {
            index = 0;
        }

        // Create caption
        var bronCaption = $j('<div></div>').attr({
            "id": this.uniqueId("bronCaption" + htmlId + gegevensbron.id + index),
            "class": "bronCaption"
        });

        if (createSimple) {
            bronCaption.append(title);
            return bronCaption;
        }

        var collapseImg = $j('<img src="' + this.options.minusicon + '" alt="Dichtklappen" title="Dichtklappen" />');
        collapseImg.click(function() {
            me.toggleBron($j(this));
        });
        bronCaption.append(collapseImg);
        bronCaption.append(' ' + title);

        var icon = $j('<img src="' + this.options.csvexporticon + '"/>').attr({
            "alt": "Exporteer naar CSV bestand",
            "title": "Exporteer naar CSV bestand"
        }).click(function() {
             me.getParent().B3PGissuite.viewercommons.exportObjectData2CSV(htmlId, gegevensbron, index, me.idcounter++);
        });

        var iconPdf = $j('<img src="' + this.options.pdficon + '"/>').attr({
            "alt": "Exporteer records met kaartuitsnede naar PDF",
            "title": "Exporteer records met kaartuitsnede naar PDF"
        }).click(function() {
            me.getParent().B3PGissuite.viewercommons.exportObjectData2PDF(htmlId, gegevensbron, index, me.idcounter++);
        });

        var icona = $j('<img src="' + this.options.infoexporticon + '" alt="Info Export" alt="Info Export"/>').attr({
            "alt": "Toon info van alle objecten in de kaartlaag",
            "title": "Toon info van alle objecten in de kaartlaag"
        }).click(function() {
            me.getParent().B3PGissuite.viewercommons.exportObjectData2HTML(htmlId, gegevensbron, index, me.idcounter++);
        });

        bronCaption.append(" ");
        if (gegevensbron.records) {
            bronCaption.append(icon);
            bronCaption.append(" ");
            bronCaption.append(icona);
            bronCaption.append(" ");
            bronCaption.append(iconPdf);
        }

        return bronCaption;
    },

    createTableHead: function(labels, simple) {
        var me = this,
            createSimple = false;
        if (simple) {
            createSimple = true;
        }
        // Create table heading
        var trHead = $j('<tr></tr>');
        if (!createSimple) {
            var volgnr = $j('<th></th>').css({
                "width": "50px"
            })
                    .html('Volgnr');
            trHead.append(volgnr);
        }
        $j.each(labels, function(index, label) {
            var th = me.createTableTh(label, null);
            trHead.append(th);
        });
        return trHead;
    },

    createTableTh: function(label, gegevensbron) {
        var kolomBreedte = (label.kolomBreedte == 0) ? 150 : label.kolomBreedte;
        var th = $j('<th></th>');
        if(gegevensbron !== null && gegevensbron.layout !== "admindata3") {
            th.css({
                "width": kolomBreedte + "px"
            });
        };
        th.html(label.label);
        return th;
    },

    /* only numbers and math operators are valid */
    containsInvalidEvalChars: function(evalStr) {
        var pattern = /[^0-9-+/*%()]/;

        return pattern.test(evalStr);
    },

    evalObjectDataCommando: function(commando) {
        var value;

        /* remove = and spaces */
        var evalString = commando.substring(1, commando.length).replace(/ /g, '');

        if (!this.containsInvalidEvalChars(evalString)) {
            var waarde = eval(evalString);
            if (/[.,]/.test(waarde)) { // Fix to 3 decimals
                value = waarde.toFixed(3);
            } else {
                value = waarde;
            }
        } else {
            value = "Fout in " + evalString;
        }

        return value;
    },

    createTableTd: function(waarde, gegevensbron, record) {
        var kolomBreedte = (waarde.kolomBreedte == 0) ? 150 : waarde.kolomBreedte;
        var me = this;
        var td = $j('<td></td>');

        if(gegevensbron.layout !== "admindata3") {
            td.css({
                "width": kolomBreedte + "px"
            });
        }

        if (waarde.type == 'TYPE_DATA' || waarde.type == 'TYPE_DATUM') {
            if (!waarde.value) {
                td.html("-");
            } else {
                /* In data .html vervangen door klikbare links. Gebruiken voor vervangen 
                 * komma gescheiden html links in verwijzingNaarTekst */
                var links;
                var html = "";
                var type;
                var imgHtml;
                if (waarde.value.indexOf(".htm") != -1 || waarde.value.indexOf(".htm") != -1 ||
                        waarde.value.indexOf(".pdf") != -1 || waarde.value.indexOf(".txt") != -1) {

                    if (waarde.value.indexOf(",") != -1) {
                        links = this.trim(waarde.value, ' ').split(",");
                    }

                    if (links) {
                        html = "";
                        for (var i in links) {
                            if (links[i].indexOf("t_") != -1) {
                                type = "toelichting";
                            } else if (links[i].indexOf("tb_") != -1) {
                                type = "bijlagen bij toelichting";
                            } else if (links[i].indexOf("r_") != -1) {
                                type = "regels";
                            } else if (links[i].indexOf("rb_") != -1) {
                                type = "bijlagen";
                            } else {
                                type = links[i];
                            }

                            if (links[i].indexOf(".pdf") != -1) {
                                imgHtml = "<img src=" + this.options.pdficon + " alt=\"" + type + "\" title=\"" + type + "\" border=0>";
                            } else {
                                imgHtml = "<img src=" + this.options.urlicon + " alt=\"" + type + "\" title=\"" + type + "\" border=0>";
                            }

                            html += " <a href=" + links[i] + " target=_blank>" + imgHtml + "</a>";
                        }

                        td.html(html);
                    }
                } else {
                    if (waarde.eenheid) {
                        td.html(waarde.value + ' ' + waarde.eenheid);
                    } else {
                        td.html(waarde.value);
                    }
                }
            }
        }
        
        if (waarde.type == 'TYPE_URL') {
            if (!waarde.value) {
                td.html("-");
            } else {
                var icon = $j('<img src="' + this.options.infoicon + '" alt="Aanvullende informatie" title="Aanvullende informatie" />')
                        .click(function() {
                    me.popUp(waarde.value, 'aanvullende_info_scherm', 500, 600);
                });
                td.html(icon);
            }
        }

        if (waarde.type == 'TYPE_FUNCTION') {
            if (!waarde.value) {
                td.html("-");
            } else if (waarde.value.search('###') != -1) {
                var funcarray = waarde.value.split('###');
                var fLink = null;
                if (funcarray[0] == "null") {
                    fLink = $j('<img id="' + this.uniqueId('jsFunction_') + '" src="' + this.options.flagicon + '" alt="Voer functie uit" title="Voer functie uit" />');
                } else {
                    fLink = $j('<a href="#" id="' + this.uniqueId('jsFunction_') + '">' + funcarray[0] + '</a>');
                }
                fLink.click(function() {
                    me.executeFunction(funcarray[1], this);
                });
                td.html(fLink);
            } else {
                var icon3 = $j('<img id="' + this.uniqueId('jsFunction_') + '" src="' + this.options.flagicon + '" alt="Voer functie uit" title="Voer functie uit" />')
                        .click(function() {
                    me.executeFunction(waarde.value, this);
                });
                td.html(icon3);
            }
        }

        if (waarde.type == 'TYPE_GOOGLENAV') {
            var gIcon = $j('<img src="' + this.options.googleIcon + '" alt="Navigeer hierheen vanaf startlocatie" title="Navigeer hierheen vanaf startlocatie" />')
                    .click(function() {

                var id = gegevensbron.id;
                var pk = gegevensbron.adminPk;
                var val = record.id;

                me.getParent().B3PGissuite.viewercommons.getDestinationWkt(id, pk, val);
            });
            td.html(gIcon);
        }

        if (waarde.type == 'TYPE_QUERY') {
            if (waarde.valueList.length > 1) {
                var labels = waarde.value.split(',');
            }

            /* Een Objectdata veld met een berekening, bijvoorbeeld =[A]*[B] */
            if (waarde.valueList && waarde.valueList.length == 1) {
                var commando = waarde.valueList[0];

                if (commando && commando.charAt(0) == '=') {
                    var value = this.evalObjectDataCommando(waarde.valueList[0]);
                    td.append(value);

                    return td;
                }
            }

            if (commando && commando.indexOf("ReportServlet") !== -1) {
                var recordId = record.values[0].value;

                var iconReport = $j('<img src="' + this.options.pdficon + '"/>').attr({
                    "alt": "Maak rapport",
                    "title": "Maak rapport"
                }).click(function() {
                    me.getParent().B3PGissuite.viewercommons.exportObjectdata2Report(recordId, commando, gegevensbron);
                });

                td.append(iconReport);
                return td;
            }

            var i = 0;
            $j.each(waarde.valueList, function(index3, listWaarde) {
                var splitWaardes = "";
                var ext = "";

                if (waarde.value != null && waarde.value != '') {
                    splitWaardes = waarde.value.split(".");
                    ext = splitWaardes[splitWaardes.length - 1];
                }

                if (!listWaarde) {
                    td.append("-");
                } else {
                    var linkspan = $j('<span></span>');
                    var clickable = null;
                    if (labels) {
                        clickable = $j('<a href="#">' + labels[i] + '</a>')
                                .attr({
                            "title": listWaarde
                        });
                        i++;
                    } else if (ext == 'pdf') {
                        clickable = $j('<a href="#"><img src="' + me.options.pdficon + '" alt="Bekijk PDF" border="0" /></a>')
                                .attr({
                            "title": listWaarde
                        });
                    } else if (splitWaardes.length > 1 && ext != 'pdf') {
                        clickable = $j('<a href="#"><img src="' + me.options.docicon + '" alt="Bekijk document" border="0" /></a>')
                                .attr({
                            "title": listWaarde
                        });
                    } else if (waarde.value) {
                        clickable = $j('<a href="#">' + waarde.value + '</a>')
                                .attr({
                            "title": listWaarde
                        });
                    } else {
                        // TODO: icon kiezen afh van extentie listWaarde
                        clickable = $j('<img src="' + me.options.urlicon + '" alt="Externe informatie" border="0"/>')
                                .attr({
                            "title": listWaarde
                        });
                    }
                    clickable.click(function() {
                        me.popUp(listWaarde, 'externe_link', 1050, 550);
                    });
                    linkspan.html(clickable);
                    td.append(linkspan);
                    td.append(" ");
                }
            });
        }

        return td;
    },

    createEmptyRow: function(size, isChild) {
        var tr = $j('<tr></tr>');
        var td = $j('<td></td>').attr({
            "colSpan": size
        })
                .html("Er zijn geen gegevens gevonden.")
                .css("font-size", isChild ? "1em" : "1.2em")
                .css("font-weight", "bold")
                .css("color", "#808080");

        tr.append(td);

        return tr;
    },
    
    createEmptyBronContent: function(htmlId, gegevensbronId) {
        // Create empty row
        var bronContent = $j('<div></div>').attr({
            "id": "bronContent" + htmlId + gegevensbronId + "_11",
            "class": "bronContent"
        });
        // Append all to DOM tree
        bronContent.append($j('<table></table>').append($j('<tbody></tbody>').append('<tr><td colspan="2">Geen data gevonden</td></tr>')));
        return bronContent;
    },
      
    /**
     * In the Gisviewerconfig is het mogelijk om javascript commando's te gebruiken die worden
     * uitgevoerd.
     */
    executeFunction: function(functionString, element) {
        var functionName = functionString.substring(0, functionString.indexOf('('));
        if(typeof this[functionName] !== 'function') {
            return;
        }
        var functionArguments = functionString.substring(functionString.indexOf('(') + 1, functionString.length - 1).split(",");
        // First arguments should be element (this is passed from the server but context is different)
        functionArguments[0] = element;
        // Excecute function with arguments
        this[functionName].apply(this, functionArguments.map(function(arg) {
            if(typeof arg !== 'string') {
                return arg;
            }
            arg = arg.trim().replace(/\'/g, '');
            if(arg === 'null') {
                return null;
            }
            return arg;
        }));
    },

    /*
     * Hier staan alle javascriptfuncties. Deze kunnen worden aangeroepen door bij
     * de themadata aan te geven dat het veld van het type javascript is. Het commando
     * wat je dan invult is de naam van de functie.
     * De functie wordt altijd met de volgende parameters aangeroepen:
     * 
     * element: het html element dat is aangeklikt
     * themaid: id van het thema
     * keyName: primairy key name
     * keyValue: waarde van de primairy key
     * attributeName: gekozen (in themadata) attribuut naam
     * attributeValue: waarde van het attribuut
     * eenheid: eventueel eenheid voor omrekenen
     */
    setAttributeValue: function(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        var oldValue = element.innerHTML;
        var newValue;

        if (oldValue == '0' || oldValue == 0) {
            newValue = 1;
        } else if (oldValue == '1' || oldValue == 1) {
            newValue = 0;
        }

        if (oldValue == 'Nee' || oldValue == 'nee') {
            newValue = 'ja';
        } else if (oldValue == 'Ja' || oldValue == 'ja') {
            newValue = 'nee';
        }

        var me = this;
        JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, function(str) {
            me.handleSetAttribute(str);
        });
    },

    setAttributeStringValue: function(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        var oldValue = element.innerHTML;
        var newValue;

        if (oldValue == '0') {
            newValue = '1';
        } else if (oldValue == '1') {
            newValue = '0';
        }

        if (oldValue == 'Nee' || oldValue == 'nee') {
            newValue = 'ja';
        } else if (oldValue == 'Ja' || oldValue == 'ja') {
            newValue = 'nee';
        }

        if (oldValue == 'TRUE' || oldValue == 'true') {
            newValue = 'false';
        } else if (oldValue == 'FALSE' || oldValue == 'false') {
            newValue = 'true';
        }

        var me = this;
        JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, function(str) {
            me.handleSetAttribute(str);
        });
    },

    setStatusValue: function(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        var oldValue = element.innerHTML;
        var newValue;

        if (oldValue == '' || oldValue == 'Nieuw' || oldValue == 'nieuw') {
            newValue = 'afgemeld';
        } else {
            newValue = 'nieuw';
        }

        var me = this;
        JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, function(str) {
            me.handleSetAttribute(str);
        });
    },

    setStatusValueDigitree: function(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        /* Nu wordt er gegeken naar wat de waarde is die in de link staat,
         * deze wordt gebruikt, niet attributeValue */
        var oldValue = element.innerHTML;

        if (oldValue == 'Leeg' || oldValue == 'Nee' || oldValue == 'Nieuw' || oldValue == 'nieuw') {
            var newValue = 'Ja';
            var me = this;
            JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, function(str) {
                me.handleSetAttribute(str);
            });
        }

        /* TODO: Nadenken over hoe data terug te wijzigen als record niet meer voorkomt
         * in view na eerste wijziging. Bijvoorbeeld een view die alleen statussen Nieuw
         * toont zal het record na deze setValue niet meer teruggeven */
        if (oldValue == 'Ja') {
            B3PGissuite.commons.messagePopup("Informatie", "Waarde is al gewijzigd.", "information");
        }
    },

    setAttributeText: function(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        var me = this;
        if (this.isOpen) {
            this.currentEl.style.display = 'block';
        }
        this.isOpen = true;
        this.currentEl = element;
        this.currentThemaid = themaid;
        this.currentKeyName = keyName;
        this.currentKeyValue = keyValue;
        this.currentAttributeName = attributeName;
        this.currentEenheid = eenheid;
        var opmerkingenedit = document.getElementById('opmerkingenedit');
        var pos = B3PGissuite.commons.findPos(element);
        opmerkingenedit.style.left = pos[0] - 1 + 'px';
        opmerkingenedit.style.top = pos[1] - 1 + 'px';
        opmerkingenedit.style.display = 'block';
        document.getElementById('opmText').focus();
        element.style.display = 'none';
        document.getElementById('opmText').value = attributeValue;
        document.getElementById('opmOkButton').onclick = function() {
            JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, document.getElementById('opmText').value, function(str) {
                me.handleSetText(str);
            });
        };
        document.getElementById('opmCancelButton').onclick = function() {
            document.getElementById('opmerkingenedit').style.display = 'none';
            element.style.display = 'block';
            me.isOpen = false;
        };
        return false;
    },

    /* Dummy to: function test Javascript in: function objectdata */
    doDummy: function(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        var msg = "elem=" + element + " themaid=" + themaid + " keyname=" + keyName + " keyval=" + keyValue + " attrname=" + attributeName + " attrval=" + attributeValue + " eenh=" + eenheid;

        B3PGissuite.commons.messagePopup("Dummy js functie", msg, "information");
    },

    /**
     *Calculate the Area of the object.
     */
    berekenOppervlakte: function(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        if (attributeName === null || attributeValue === null) {
            attributeName = keyName;
            attributeValue = keyValue;
        }
        var me = this;
        JMapData.getArea(element.id, themaid, attributeName, attributeValue, eenheid, function(str) {
            me.handleGetArea(str);
        });
    },

    /**
     * handle the returned value
     */
    handleSetAttribute: function(str, msg) {
        var message = msg || "Kon attribuut niet instellen.";
        if (str[0] === null || str[0] === "") {
            B3PGissuite.commons.messagePopup("Fout", message, "error");
        } else {
            var element = document.getElementById(str[0]);
            if(element && element.tagName.toLowerCase() === 'img') {
                element.style.display = 'none';
                var spanElement = document.createElement('span');
                spanElement.innerHTML = str[1];
                element.parentNode.appendChild(spanElement);
                return;
            }
            element.innerHTML = str[1];
        }
    },

    handleSetText: function(str) {
        var me = this;
        document.getElementById('opmerkingenedit').style.display = 'none';
        document.getElementById(str[0]).innerHTML = str[1];
        document.getElementById(str[0]).onclick = function() {
            me.setAttributeText(this, me.currentThemaid, me.currentKeyName, me.currentKeyValue, me.currentAttributeName, str[1], me.currentEenheid);
        };
        document.getElementById(str[0]).style.display = 'block';
        isOpen = false;
    },

    /**
     *Handle the returned area.
     */
    handleGetArea: function(str) {
        this.handleSetAttribute(str, "Kon oppervlakte niet berekenen.");
    },

    trim: function(str, chars) {
        return this.ltrim(this.rtrim(str, chars), chars);
    },

    ltrim: function(str, chars) {
        chars = chars || "\\s";
        return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
    },

    rtrim: function(str, chars) {
        chars = chars || "\\s";
        return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
    },

    showMaatregel: function(element, gegevensbronId, naampk, waardepk, naamingevuldekolom, waardeingevuldekolom, waardevaneenheidkolom) {
        if (waardeingevuldekolom == "null") {
            waardeingevuldekolom = null;
        }
        this.getParent().showMaatregel(waardeingevuldekolom, gegevensbronId, waardepk);

    },

    highlightFeature: function(element, themaid, naampk, waardepk, naamingevuldekolom, waardeingevuldekolom, waardevaneenheidkolom) {
        if (naamingevuldekolom == null || waardeingevuldekolom == null) {
            naamingevuldekolom = naampk;
            waardeingevuldekolom = waardepk;
        }
        var sldstring = window.location.protocol + "//" + window.location.host + "/gisviewer/CreateSLD";
        //"<%=request.getAttribute('absoluteURLPrefix') %>" +  "<html:rewrite page="/SldServlet" module=""/>";

        var ouder = this.getParent();
        var fmco = this.getParent().B3PGissuite.vars.webMapController;
        if (fmco == undefined) {
            ouder = this.getParent().B3PGissuite.commons.getParent();
            fmco = ouder.B3PGissuite.vars.webMapController;
        }
        var mapje = fmco.getMap();
        var existingLayer = mapje.getAllWMSLayers()[0];
        var wmsLayer = this.searchThemaValue(ouder.B3PGissuite.config.themaTree, themaid, "wmslayers");
        var visValue = this.trim(waardepk);
        if (waardeingevuldekolom != null && waardeingevuldekolom.length > 0) {
            visValue = this.trim(waardeingevuldekolom);
        }
        visValue = visValue.replace(" ", "%20");
        sldstring += "?visibleValue=" + visValue;
        sldstring += "&id=" + themaid;
        var beginChar = "?";
        if (existingLayer.getURL().indexOf("?") != -1) {
            beginChar = "&";
        }

        sldstring = escape(sldstring);

        var sldUrl = existingLayer.getURL() + beginChar + "SLD=" + sldstring;
        var ogcOptions = {
            transparent: true,
            format: existingLayer.getOption("format"),
            layers: wmsLayer,
            exceptions: existingLayer.getOption("exceptions"),
            srs: existingLayer.getOption("srs"),
            version: existingLayer.getOption("version")
        };
        var options = {
            id: "sldLayer",
            timeout: "30",
            retryonerror: "10",
            getcapabilitiesurl: existingLayer.getURL(),
            getfeatureinfourl: existingLayer.getURL(),
            showerrors: true
        };
        var sldLayer = fmco.createWMSLayer("sldLayer", sldUrl, ogcOptions, options);
        mapje.addLayer(sldLayer);//true,true
    },

    /**
     *Functie zoekt een waarde op (val) van een thema met id
     * themaId uit de thematree list die meegegeven is.
     * @param themaList
     * @param themaId
     * @param val
     **/
    searchThemaValue: function(themaList, themaId, val) {
        var me = this;
        for (var i in themaList) {
            if (i == "id" && themaList[i] == themaId) {
                return themaList[val];
            }

            if (i == "children") {
                for (var ichild in themaList[i]) {
                    var returnValue = me.searchThemaValue(themaList[i][ichild], themaId, val);
                    if (returnValue !== undefined && returnValue !== null) {
                        return returnValue;
                    }

                }
            }
        }

        return null;
    }

});