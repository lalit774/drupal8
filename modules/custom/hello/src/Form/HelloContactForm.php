<?php
namespace Drupal\hello\Form;

use Drupal\Core\DependencyInjection\ContainerInjectionInterface;
use Drupal\Core\Form\FormInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Session\AccountProxyInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Drupal\hello\HelloContactStorage;
use Symfony\Component\DependencyInjection\ContainerInterface;

class HelloContactForm implements FormInterface, ContainerInjectionInterface {
    use StringTranslationTrait;


    protected $currentUser;

    public static function create(ContainerInterface $container){
        $form = new static(
            $container->get('current_user')
        );
        // The StringTranslationTrait trait manages the string translation service
        // for us. We can inject the service here.
        $form->setStringTranslation($container->get('string_translation'));
        return $form;
    }

    /**
     * Construct the new form object.
     */
    public function __construct(AccountProxyInterface $current_user) {
        $this->currentUser = $current_user;
    }

    /**
     * {@inheritdoc}
     */
    public function getFormId() {
        return 'contact_form';
    }

    /**
     * {@inheritdoc}
     */
    public function buildForm(array $form, FormStateInterface $form_state) {
        $form = [];

        $form['message'] = [
            '#markup' => $this->t('Add an entry to the contact table.'),
        ];

        $form['contact'] = [
            '#type' => 'fieldset',
            '#title' => $this->t('Add a person entry'),
        ];
        $form['contact']['name'] = [
            '#type' => 'textfield',
            '#title' => $this->t('Name'),
            '#size' => 15,
        ];
        $form['contact']['surname'] = [
            '#type' => 'textfield',
            '#title' => $this->t('Surname'),
            '#size' => 15,
        ];
        $form['contact']['age'] = [
            '#type' => 'textfield',
            '#title' => $this->t('Age'),
            '#size' => 5,
            '#description' => $this->t("Values greater than 127 will cause an exception. Try it - it's a great example why exception handling is needed with contact."),
        ];
        $form['contact']['submit'] = [
            '#type' => 'submit',
            '#value' => $this->t('Send'),
        ];

        return $form;
    }

    /**
     * {@inheritdoc}
     */
    public function validateForm(array &$form, FormStateInterface $form_state) {
        // Verify that the user is logged-in.
        if ($this->currentUser->isAnonymous()) {
            $form_state->setError($form['contact'], $this->t('You must be logged in to add values to the database.'));
        }
        // Confirm that age is numeric.
        if (!intval($form_state->getValue('age'))) {
            $form_state->setErrorByName('age', $this->t('Age needs to be a number'));
        }
    }

    /**
     * {@inheritdoc}
     */
    public function submitForm(array &$form, FormStateInterface $form_state) {
        // Gather the current user so the new record has ownership.
        $account = $this->currentUser;
        // Save the submitted entry.
        $entry = [
            'name' => $form_state->getValue('name'),
            'surname' => $form_state->getValue('surname'),
            'age' => $form_state->getValue('age'),
            'uid' => $account->id(),
        ];
        $return = HelloContactStorage::insert($entry);
        if ($return) {
            drupal_set_message($this->t('Created entry @entry', ['@entry' => print_r($entry, TRUE)]));
        }
    }

}