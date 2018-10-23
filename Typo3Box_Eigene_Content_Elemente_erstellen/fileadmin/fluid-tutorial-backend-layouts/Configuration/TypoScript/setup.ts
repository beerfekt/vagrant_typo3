
page = PAGE
page {
    10 = FLUIDTEMPLATE
    10 {
        layoutRootPaths {
            10 =fileadmin/fluid-tutorial-backend-layouts/Resources/Private/Layouts
        }

        partialRootPaths {
            10 =fileadmin/fluid-tutorial-backend-layouts/Resources/Private/Partials
        }

        templateRootPaths {
            10 =fileadmin/fluid-tutorial-backend-layouts/Resources/Private/Templates
        }
        /*

        ############## BACKEND LAYOUTS #############


        # ---- Variante 1 - statisch ---------


        #template-name bestimmen
        templateName.stdWrap.cObject = CASE
        templateName.stdWrap.cObject {
        key.data = pagelayout

        #switching der templates

        #fallback default
        default = TEXT
        default.value = ForLayouts

        #einespalte
        pagets__einespalte = TEXT
        pagets__einespalte.value = ForLayouts
        #zweispalten
        pagets__zweispalten = TEXT
        pagets__zweispalten.value = ForLayouts2

        }
        */

        #variante2 - dynamisch (bootstrap)
        templateName = TEXT
        templateName {
            cObject = TEXT
            cObject {
                data = pagelayout
                required = 1
                case = uppercamelcase
                split {
                    token = pagets__
                    cObjNum = 1
                    1.current = 1
                }
            }
            ifEmpty = Default
        }

        ##################################################

    }
}

#rendering the content in the template
lib.content {
    render = CONTENT
    render {
        table = tt_content
        select {
            orderBy = sorting
            where.cObject = COA
            where.cObject {
                10 = TEXT
                10 {
                    field = colPos
                    intval = 1
                    ifEmpty = 0
                    noTrimWrap = | AND colPos=||
                }
            }
        }
    }
}





#------ navigation, breadcrump ----------
lib {
    topNavigation = HMENU
    topNavigation {
        1 = TMENU
        1.NO.linkWrap = | |*| &nbsp;&nbsp;&nbsp; |*|
    }
    breadcrumbTrail = HMENU
    breadcrumbTrail {
        special = rootline
        special.range = 0|-1
        1 = TMENU
        1.NO {
            stdWrap.field = nav_title // title
            ATagTitle.field = nav_title // title
            linkWrap = | |*| &nbsp;&raquo;&nbsp; |*|
        }
        1.CUR = 1
        1.CUR {
            doNotLinkIt = 1
            stdWrap.field = nav_title // title
            linkWrap = | |*| &nbsp;&raquo;&nbsp;<em>|</em>|
        }
    }
}


