#As defined in Configuration/TCA/Overrides/tt_content.php,
#this file is in the directory Configuration/TypoScript of our own extension.




#Templates include
#To ensure your custom content element templates can be found you need to extend the
#global templateRootPaths with a path within your extension:
lib.contentElement {
    templateRootPaths {
        #You can use an arbitrary index (200 here), just make sure it is unique.
        200 = EXT:content_elements/Resources/Private/Templates/


    }
}

#custom-content-element definition/konfiguration

tt_content {
    #definition des identifiers des betreff. custom-elementes
    content_elements_kaese =< lib.contentElement
    content_elements_kaese {
        #register the rendering of the custom element using a fluid template
        templateName = NewContentElement
        # You can use data processors for some data manipulation or other stuff you would like to do before sending everything to the view.
        # This is done in the dataProcessing section where you can add an arbitrary number of data processors,
        # each with a fully qualified class name (FQCN) and optional parameters to be used in the data processor:
        dataProcessing {
            1 = SV\ContentElements\DataProcessing\NewContentElementProcessor
            1 {
                # typo3conf/ext/content_elements/Classes/DataProcessing/NewContentElementProcessor.php
                useHere = theConfigurationOfTheDataProcessor
            }
        }
    }
}


