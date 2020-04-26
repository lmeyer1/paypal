<?php


namespace PaypalAddons\classes\API\Request;


use PaypalAddons\classes\AbstractMethodPaypal;
use PaypalAddons\classes\API\Response\Error;
use PaypalAddons\classes\API\Response\ResponseOrderCapture;
use PayPalCheckoutSdk\Core\PayPalHttpClient;
use PayPalCheckoutSdk\Orders\OrdersAuthorizeRequest;
use PayPalHttp\HttpException;
use Symfony\Component\VarDumper\VarDumper;

class PaypalOrderAuthorizeRequest extends RequestAbstract
{
    /** @var string*/
    protected $paymentId;

    public function __construct(PayPalHttpClient $client, AbstractMethodPaypal $method, $paymentId)
    {
        parent::__construct($client, $method);
        $this->paymentId = $paymentId;
    }

    public function execute()
    {
        $response = new ResponseOrderCapture();
        $orderAuthorize = new OrdersAuthorizeRequest($this->paymentId);
        $orderAuthorize->headers = array_merge($this->getHeaders(), $orderAuthorize->headers);

        try {
            $exec = $this->client->execute($orderAuthorize);

            if (in_array($exec->statusCode, [200, 201, 202])) {
                $response->setSuccess(true)
                    ->setData($exec)
                    ->setPaymentId($exec->result->id)
                    ->setTransactionId($this->getTransactionId($exec))
                    ->setCurrency($this->getCurrency($exec))
                    ->setCapture($this->getCapture($exec))
                    ->setTotalPaid($this->getTotalPaid($exec))
                    ->setStatus($exec->result->status)
                    ->setPaymentMethod($this->getPaymentMethod())
                    ->setPaymentTool($this->getPaymentTool())
                    ->setMethod($this->getMethodTransaction())
                    ->setDateTransaction($this->getDateTransaction($exec));
            } elseif ($exec->statusCode == 204) {
                $response->setSuccess(true);
            } else {
                $error = new Error();
                $resultDecoded = json_decode($exec->message);
                $error->setMessage($resultDecoded->message);

                $response->setSuccess(false)->setError($error);
            }
        } catch (HttpException $e) {
            $error = new Error();
            $resultDecoded = json_decode($e->getMessage());
            $error->setMessage($resultDecoded->message)->setErrorCode($e->getCode());

            $response->setSuccess(false)
                ->setError($error);
        } catch (\Exception $e) {
            $error = new Error();
            $error->setErrorCode($e->getCode())->setMessage($e->getMessage());
            $response->setError($error);
        }

        return $response;
    }

    protected function getTransactionId($exec)
    {
        return $exec->result->purchase_units[0]->payments->authorizations[0]->id;
    }

    protected function getCurrency($exec)
    {
        return $exec->result->purchase_units[0]->payments->authorizations[0]->amount->currency_code;
    }

    protected function getCapture($exec)
    {
        return false;
    }

    protected function getTotalPaid($exec)
    {
        return $exec->result->purchase_units[0]->payments->authorizations[0]->amount->value;
    }

    protected function getPaymentTool()
    {
        return '';
    }

    protected function getPaymentMethod()
    {
        return 'paypal';
    }

    protected function getDateTransaction($exec)
    {
        $payemnts = $exec->result->purchase_units[0]->payments;
        $transaction = $payemnts->authorizations[0];
        $date = \DateTime::createFromFormat(\DateTime::ATOM, $transaction->create_time);

        return $date;
    }

    protected function getMethodTransaction()
    {
        switch (get_class($this->method)) {
            case 'MethodEC':
                $method = 'EC';
                break;
            case 'MethodMB':
                $method = 'MB';
                break;
            case 'MethodPPP':
                $method = 'PPP';
                break;
            default:
                $method = '';
        }

        return $method;
    }
}
