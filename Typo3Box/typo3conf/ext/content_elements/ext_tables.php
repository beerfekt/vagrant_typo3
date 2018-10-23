<?php
defined('TYPO3_MODE') || die('Access denied.');

/**
 * Extension bekannt machen
 */


call_user_func(
    function()
    {
        \TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addStaticFile('content_elements', 'Configuration/TypoScript', 'Content Elements');
    }
);





