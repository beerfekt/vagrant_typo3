<?php


// ################## Eigener Content Element in selbstdefinierten Reiter einfügen: ##########################


//Eigener Reiter:  "Content Element Wizard" - definiert in:


// Adds the content element to the "Type" dropdown in the backend


/***************
 * Add content element group to selector list
 */
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
    [
        //'Eigene Elemente',
        //TODO: LLL geht nicht
        'LLL:EXT:content_elements/Resources/Private/Language/Tca.xlf:eigene-elemente',
        '--div--'
    ],
    '--div--',
    'before'
);


/***************
 * Add content element to selector list
 */
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
    [
        #name (angezeigt im Backend)
        'LLL:EXT:content_elements/Resources/Private/Language/Tca.xlf:eigene-elemente-title',
        #identifier des custom-elementes (definiert in setup.ts der extension)
        'content_elements_kaese',
        #icon-identifier (registriert/definiert in ext_localconf.php)
        'content_elements_icon'
    ],
    '--div--',
    'after'
);





// ################## Felder der Detailansicht ##########################


// Configure the default backend fields for the content element
$GLOBALS['TCA']['tt_content']['types']['content_elements_kaese'] = array(
    'showitem' => '
      --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:general,
         --palette--;;general,
         --palette--;;headers,
         bodytext;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:bodytext_formlabel,
      --div--;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:tabs.appearance,
         --palette--;;frames,
         --palette--;;appearanceLinks,
      --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:language,
         --palette--;;language,
      --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:access,
         --palette--;;hidden,
         --palette--;;access,
      --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:categories,
         categories,
      --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:notes,
         rowDescription,
      --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:extended,
   ',
    'columnsOverrides' => [
        'bodytext' => [
            'config' => [
                'enableRichtext' => true,
                'richtextConfiguration' => 'default'
            ]
        ]
    ]
);





?>