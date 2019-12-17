SELECT Language_code, NLS_language, Installed_flag
  FROM fnd_languages
 WHERE installed_flag IN ('I', 'B')
