{extends file='parent:frontend/index/index.tpl'}

{block name="frontend_index_header_javascript_jquery"}
    {$smarty.block.parent}
    <script async>

        var _paq = _paq || [];

        {* ----- TRACKING DETAIL ----- *}
        {if $Controller == "detail"}
        _paq.push([
            'setEcommerceView',
            '{$sArticle.ordernumber}',
            '{$sArticle.articleName|escape:'javascript'}',
            '{$sCategoryInfo.name|escape:'javascript'}'
        ]);
        {/if}

        {* ----- TRACKING CATEGORY ----- *}
        {if $Controller == "listing"}
        _paq.push([
            'setEcommerceView',
            false,
            false,
            '{$sCategoryContent.name|escape:'javascript'}'
        ]);
        {/if}

        {if $TinectMatomo.ecommerce}
            {* ----- TRACKING ORDERS WITH ARTICLES ----- *}
            {if $sBasket.content && $sOrderNumber}
            {if $sAmountWithTax}
            {assign var="sAmountTax" value=$sAmountWithTax|replace:",":"."}
            {else}
            {assign var="sAmountTax" value=$sAmount|replace:",":"."}
            {/if}

            {if $sAmountNet}
            {assign var="sAmountNumeric" value=$sAmountNet|replace:",":"."}
            {else}
            {assign var="sAmountNumeric" value=$sAmount|replace:",":"."}
            {/if}

            {assign var="sAmountTax2" value=$sAmountTax-$sAmountNumeric}
            {assign var="sAmountshipping1" value=$sShippingcosts|replace:",":"."}
            {assign var="sAmountsubtotal" value=$sAmountTax-$sAmountshipping1}

            {foreach from=$sBasket.content item=sBasketItem}
            _paq.push([
                'addEcommerceItem',
                '{$sBasketItem.ordernumber|escape:'javascript'}',
                '{$sBasketItem.articlename|escape:'javascript'}',
                ' ',
                '{$sBasketItem.priceNumeric|round:2}',
                '{$sBasketItem.quantity}'
            ]);
            {/foreach}

            _paq.push([
                'trackEcommerceOrder',
                '{$sOrderNumber}',
                '{$sAmountTax|round:2}',
                '{$sAmountsubtotal|round:2}',
                '{$sAmountTax2|round:2}',
                '{$sShippingcosts|replace:',':'.'|round:2}',
                false
            ]);
            {/if}
        {/if}

        _paq.push(['trackPageView']);
        _paq.push(['enableLinkTracking']);


        {block name="frontend_tinectmatomno_paq"}
        {*
        Use this block to push data to _paq
        *}
        {/block}


        {*
        TODO: check if it can be compressed
        *}
        (function () {
            var u = "{$TinectMatomo.matomopath}";
            _paq.push(['setTrackerUrl', u + '/{$TinectMatomo.phppath}']);
            _paq.push(['setSiteId', '{$TinectMatomo.siteid}']);
            var d = document, g = d.createElement('script'), s = d.getElementsByTagName('script')[0];
            g.type = 'text/javascript';
            g.async = true;
            g.defer = true;
            g.src = u + '/{$TinectMatomo.jspath}';
            s.parentNode.insertBefore(g, s);
        })();


    </script>
{/block}