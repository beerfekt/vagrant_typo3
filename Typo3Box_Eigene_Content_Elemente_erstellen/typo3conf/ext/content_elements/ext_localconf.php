<?php



//Hier werden die folgenden Elemente bekanntgemacht:

// ICON
// PageTSConfig
// content_element_bezeichner HOOK




/***************
 * Register Icons
 */
$iconRegistry = \TYPO3\CMS\Core\Utility\GeneralUtility::makeInstance(\TYPO3\CMS\Core\Imaging\IconRegistry::class);
$iconRegistry->registerIcon(
    'content_elements_icon',
    \TYPO3\CMS\Core\Imaging\IconProvider\SvgIconProvider::class,
    ['source' => 'EXT:content_elements/Resources/Public/Icons/ContentElements/content_elements_cheese_icon.svg']
);



/***************
 * HOOK
 */


########### generate a special preview in the backend "Web > Page" module, ##########

// Register for hook to show preview of tt_content element of CType="yourextensionkey_newcontentelement" in page module
$GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['cms/layout/class.tx_cms_layout.php']['tt_content_drawItem']['content_elements_kaese'] =
    \SV\ContentElements\Hooks\PageLayoutView\NewContentElementPreviewRenderer::class;


/***************
 * PageTSConfig
 */


## EXTENSION BUILDER DEFAULTS END TOKEN - Everything BEFORE this line is overwritten with the defaults of the extension builder
#\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addPageTSConfig(\TYPO3\CMS\Core\Utility\GeneralUtility::getURL(\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::extPath($_EXTKEY).'Configuration/TsConfig/pageTSconfig.txt'));
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addPageTSConfig('<INCLUDE_TYPOSCRIPT: source="FILE:EXT:' . $_EXTKEY . '/Configuration/TSconfig/pageTSconfig.txt">');










