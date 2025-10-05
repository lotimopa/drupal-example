<?php

namespace Drupal\lasts_posts\Hook;

use Drupal\Core\Hook\Attribute\Hook;

/**
 * Hooks relative to themes.
 */
class ThemeHooks {

  /**
   * Hoo, theme method.
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

    return $themes;
  }
}
