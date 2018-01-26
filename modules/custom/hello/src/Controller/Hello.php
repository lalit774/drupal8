<?php

namespace Drupal\hello\Controller;
use Drupal\Core\Controller\ControllerBase;
use Drupal\hello\HelloContactStorage;
/**
 * Greets the user.
 */
class Hello extends ControllerBase {
    public function content() {
        return array('#markup' => $this->t('Hello world.'));
    }

    /**
     * Render a list of entries in the database.
     */
    public function entryList() {
        $content = [];

        $content['message'] = [
            '#markup' => $this->t('Generate a list of all entries in the database. There is no filter in the query.'),
        ];

        $rows = [];
        $headers = [t('Id'), t('uid'), t('Name'), t('Surname'), t('Age')];

        foreach ($entries = HelloContactStorage::load() as $entry) {
            // Sanitize each entry.
            $rows[] = array_map('Drupal\Component\Utility\SafeMarkup::checkPlain', (array) $entry);
        }
        $content['table'] = [
            '#type' => 'table',
            '#header' => $headers,
            '#rows' => $rows,
            '#empty' => t('No entries available.'),
        ];
        // Don't cache this page.
        $content['#cache']['max-age'] = 0;

        return $content;
    }
}