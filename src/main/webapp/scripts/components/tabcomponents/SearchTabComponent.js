B3PGissuite.defineComponent('SearchTabComponent', {
    extend: 'BaseComponent',
    defaultOptions: {
        hasSearch: false,
        hasA11yStartWkt: false,
        searchConfigContainerId: 'searchConfigurationsContainer',
        searchInputContainerId: 'searchInputFieldsContainer',
        searchResultsId: 'searchResults',
        searchResultsClass: 'searchResultsClass'
    },
    constructor: function SearchTabComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        this.component = jQuery('<div></div>');

        var verwijderMarker = jQuery('<p></p>').append(jQuery('<input />').attr({
            'type': 'button',
            'class': 'knop',
            'value': 'Verwijder marker'
        }).click(function() {
            B3PGissuite.get('Search').removeSearchResultMarker();
        }));

        if(this.options.hasSearch) {
            this.component.append(verwijderMarker);
        }
        this.component.append(jQuery('<p></p>').text('Kies uit de lijst de objecten waar u op wilt zoeken en vul daarna de zoekvelden in.'));
        if(this.options.hasA11yStartWkt) {
            this.component.append(jQuery('<p></p>').text('U heeft een startlocatie ingesteld. Deze locatie staat op de kaart gemarkeerd. Bij zoekers die hier gebruik van maken wordt de afstand naar de startlocatie getoond.'));
            this.component.append(verwijderMarker);
        }

        var searchContainer = jQuery('<div></div>')
        .append(jQuery('<div></div>').attr({ 'id': this.options.searchConfigContainerId }))
        .append(jQuery('<div></div>').attr({ 'id': this.options.searchInputContainerId }))
        .append(jQuery('<br />'))
        .append(jQuery('<div></div>').attr({ 'id': this.options.searchResultsId, 'class': this.options.searchResultsClass }));
        this.component.append(searchContainer);
    }
});