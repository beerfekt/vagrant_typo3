<?php
namespace SV\ContentElements\DataProcessing;

/*
 * This file is part of the TYPO3 CMS project.
 */

use TYPO3\CMS\Frontend\ContentObject\ContentObjectRenderer;
use TYPO3\CMS\Frontend\ContentObject\DataProcessorInterface;

/**
 * Class for data processing for the content element "My new content element"
 */
class NewContentElementProcessor implements DataProcessorInterface
{

    /**
     * Process data for the content element "My new content element"
     *
     * @param ContentObjectRenderer $cObj The data of the content element or page
     * @param array $contentObjectConfiguration The configuration of Content Object
     * @param array $processorConfiguration The configuration of this processor
     * @param array $processedData Key/value store of processed data (e.g. to be passed to a Fluid View)
     * @return array the processed data as key/value store
     */
    public function process(
        ContentObjectRenderer $cObj,
        array $contentObjectConfiguration,
        array $processorConfiguration,
        array $processedData
    )
    {
        $processedData['kaese'] = 'hier erscheint wert von kaese';
        #typo3conf/ext/content_elements/Classes/DataProcessing/NewContentElementProcessor.php
        $processedData['data']['header'] = "<b>" . $processedData['data']['header'] . "</b>";

        //var_dump($processedData);




        return $processedData;
    }
}