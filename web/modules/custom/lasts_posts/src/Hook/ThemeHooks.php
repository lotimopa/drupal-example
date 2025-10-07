<?php

namespace Drupal\lasts_posts\Hook;

use Drupal\Core\Hook\Attribute\Hook;

/**
 * Hooks relative to themes.
 */
class ThemeHooks {

  /**
   * Hook theme method.
   *
   * @return array
   *   Themes list.
   */
  #[Hook(hook: 'theme')]
  public function themeHook() {
    $themes = [];

    $themes['lasts_posts'] = [
      'variables' => [
        'posts' => NULL,
      ],
    ];

    $themes['homepage'] = [
      'variables' => [],
    ];

    return $themes;
  }

}
