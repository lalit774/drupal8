<?php

namespace Drupal\hello\Controller;
use Drupal\Core\Controller\ControllerBase;
/**
 * Greets the user.
 */
class Hello extends ControllerBase {
    public function content() {
        return array('#markup' => $this->t('Hello world.'));
 }
}