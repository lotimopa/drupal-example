<?php

namespace Drupal\lasts_posts\Controller;

use Drupal\Core\Controller\ControllerBase;

/**
 * Home controller.
 */
class HomeController extends ControllerBase {

  /**
   * Build home page.
   *
   * @return array
   *   Render array.
   */
  public function buildPage(): array {
    return [
      '#theme' => 'homepage',
    ];
  }

}
