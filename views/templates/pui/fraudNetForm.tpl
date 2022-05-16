{*
* 2007-2022 PayPal
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author 2007-2022 PayPal
*  @copyright PayPal
*  @license http://opensource.org/licenses/osl-3.0.php Open Software License (OSL 3.0)
*
*}
{include file = "{$psPaypalDir}/views/templates/_partials/javascript.tpl" assign=javascriptBlock}
{$javascriptBlock nofilter}
{assign var='currentDate' value=date('Y-m-d')}

{literal}
<script type="application/json" fncls="fnparams-dede7cc5-15fd-4c75-a9f4-36c430ee3a99">
  {
    "f":"{/literal}{$sessionId}{literal}",
    "s":"{/literal}{$sourceId}{literal}",
    "sandbox": {/literal}{$isSandbox}{literal}
  }
</script>
{/literal}

<script type="text/javascript" src="https://c.paypal.com/da/r/fb.js"></script>

<form
        class="form"
        action="{Context::getContext()->link->getModuleLink('paypal','puiValidate',['sessionId' => $sessionId], true)}"
        method="POST"
        pui-form
>

  <div class="form-group row">
    <div class="col-lg-2">
      <label class="form-label" for="paypal_pui_firstname">{l s='First name' mod='paypal'}</label>

    </div>

    <div class="col-lg-6">
      <input
              required
              class="form-control"
              type="text"
              name="paypal_pui_firstname"
              id="paypal_pui_firstname"
              value="{if isset($userData)}{$userData->getFirstName()}{/if}">
    </div>
  </div>

  <div class="form-group row">
    <div class="col-lg-2">
      <label class="form-label" for="paypal_pui_lastname">{l s='Last name' mod='paypal'}</label>
    </div>

    <div class="col-lg-6">
      <input
              required
              class="form-control"
              type="text"
              name="paypal_pui_lastname"
              id="paypal_pui_lastname"
              value="{if isset($userData)}{$userData->getLastName()}{/if}">
    </div>
  </div>

  <div class="form-group row">
    <div class="col-lg-2">
      <label class="form-label" for="paypal_pui_email">{l s='E-Mail' mod='paypal'}</label>
    </div>

    <div class="col-lg-6">
      <input
              required
              class="form-control"
              type="text"
              name="paypal_pui_email"
              id="paypal_pui_email"
              value="{if isset($userData)}{$userData->getEmail()}{/if}">
    </div>
  </div>

  <div class="form-group row">
    <div class="col-lg-2">
      <label class="form-label" for="paypal_pui_birhday">{l s='Birth day' mod='paypal'}</label>
    </div>

    <div class="col-lg-6">
      <input
              required
              class="form-control"
              type="date"
              data-date={l s='DD.MM.YYYY' mod='paypal'}
              max="{$currentDate nofilter}"
              name="paypal_pui_birhday"
              id="paypal_pui_birhday"
              {literal}pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}"{/literal}
              value="{if isset($userData)}{$userData->getBirth()}{/if}"
              >
    </div>

    <style>
      input#paypal_pui_birhday {
        position: relative;
        padding: 1.1rem;
      }

      input#paypal_pui_birhday:before {
        position: absolute;
        top: .5rem; left: 1rem;
        content: attr(data-date);
        display: inline-block;
      }

      input#paypal_pui_birhday::-webkit-datetime-edit, input#paypal_pui_birhday::-webkit-inner-spin-button, input#paypal_pui_birhday::-webkit-clear-button {
        display: none;
      }

      input#paypal_pui_birhday::-webkit-calendar-picker-indicator {
        position: absolute;
        top: .5rem;
        right: 0;
        opacity: 1;
      }
    </style>

    <script>
        document.querySelector("input#paypal_pui_birhday").addEventListener("change", function() {
            var dateArray = this.value.split('-');

            if (dateArray.length != 3) {
                return;
            }

            this.setAttribute("data-date", [dateArray[2], dateArray[1], dateArray[0]].join('.'));
        })
    </script>
  </div>

  <div class="form-group row">
    <div class="col-lg-2">
      <label class="form-label" for="paypal_pui_phone">{l s='Phone' mod='paypal'}</label>
    </div>

    <div class="col-lg-6">
      <input
              required
              class="form-control"
              type="tel"
              name="paypal_pui_phone"
              id="paypal_pui_phone"
              placeholder="{l s='Example: 030123456789' mod='paypal'}"
              {literal}pattern="[0-9]{1,14}?"{/literal}
              value="{if isset($userData)}{$userData->getPhone()}{/if}">
    </div>
  </div>

  <div class="alert alert-info">
      {{l s='By clicking on the button, you agree to the [a @href1@]terms of payment[/a] and [a @href2@]performance of a risk check[/a] from the payment partner, Ratepay.' mod='paypal'}|paypalreplace:['@href1@' => {'https://www.ratepay.com/legal-payment-terms'}, '@target@' => {'target="blank"'}, '@href2@' => {'https://www.ratepay.com/legal-payment-dataprivacy'}, '@target@' => {'target="blank"'}] nofilter}
      {{l s='You also agree to PayPal’s [a @href1@]privacy statement[/a].' mod='paypal'}|paypalreplace:['@href1@' => {'https://www.paypal.com/us/webapps/mpp/ua/privacy-full?_ga=1.129822860.1014894959.1637147141'}, '@target@' => {'target="blank"'}] nofilter}
      {l s='If your request to purchase Upon invoice is accepted, the purchase price claim will be assigned to Ratepay, and you may only pay Ratepay, not the merchant.' mod='paypal'}
  </div>

  <div class="form-group row">
    <div class="col-lg-12">
      <button class="btn btn-primary">{l s='Submit' mod='paypal'}</button>
    </div>
  </div>
</form>

<script>
    if (typeof PaypalTools != 'undefined') {
        PaypalTools.disableTillConsenting(
            document.querySelector('[pui-form] button'),
            document.getElementById('conditions_to_approve[terms-and-conditions]')
        );
        PaypalTools.hideElementTillPaymentOptionChecked(
            '[data-module-name="paypal_pui"]',
            '#payment-confirmation'
        );
    } else {
        document.addEventListener('paypal-tools-loaded', function() {
            PaypalTools.disableTillConsenting(
                document.querySelector('[pui-form] button'),
                document.getElementById('conditions_to_approve[terms-and-conditions]')
            );
            PaypalTools.hideElementTillPaymentOptionChecked(
                '[data-module-name="paypal_pui"]',
                '#payment-confirmation'
            );
        });
    }
</script>