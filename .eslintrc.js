module.exports = {
  env: {
    browser: true,
    es2020: true
  },
  extends: ['@llc1123/eslint-config/prettier', '@llc1123', '@llc1123/eslint-config/react'],
  ignorePatterns: ['src/__generated__'],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: true
  },
  plugins: ['react-refresh'],
  rules: {
    '@typescript-eslint/ban-ts-comment': ['error', {
      'ts-ignore': 'allow-with-description'
    }],
    '@typescript-eslint/consistent-type-assertions': ['error', {
      assertionStyle: 'as',
      objectLiteralTypeAssertions: 'allow-as-parameter'
    }],
    '@typescript-eslint/consistent-type-definitions': ['warn', 'type'],
    '@typescript-eslint/no-confusing-void-expression': 'off',
    '@typescript-eslint/no-empty-function': 'error',
    '@typescript-eslint/no-explicit-any': ['error', {
      fixToUnknown: true
    }],
    '@typescript-eslint/no-unnecessary-condition': 'warn',
    // use [, , , ...rest] for arrays,
    // as [a, b, c, ...rest] will be warned
    '@typescript-eslint/no-unused-vars': ['error', {
      caughtErrors: 'all',
      ignoreRestSiblings: true
    }],
    '@typescript-eslint/prefer-nullish-coalescing': 'error',
    '@typescript-eslint/prefer-optional-chain': 'error',
    '@typescript-eslint/restrict-template-expressions': ['error', {
      allowNumber: true
    }],
    eqeqeq: 'error',
    'func-style': ['warn', 'expression'],
    'import/newline-after-import': 'error',
    'import/no-duplicates': 'error',
    'import/order': ['warn', {
      'newlines-between': 'always',
      pathGroups: [{
        group: 'builtin',
        pattern: '{.,@}/**/*.{css,scss,styl}',
        position: 'before'
      }, {
        group: 'builtin',
        pattern: '{.,@}/**/polyfills.{js,ts}',
        position: 'before'
      }],
      warnOnUnassignedImports: true
    }],
    'no-console': 'off',
    'no-constant-condition': 'error',
    'no-debugger': 'error',
    'no-dupe-keys': 'error',
    'no-else-return': 'error',
    'no-return-await': 'error',
    'no-throw-literal': 'off',
    'no-unexpected-multiline': 'error',
    'no-unneeded-ternary': 'error',
    'no-unreachable': 'error',
    'no-unused-expressions': ['error', {
      allowShortCircuit: true,
      allowTaggedTemplates: true,
      allowTernary: true,
      enforceForJSX: true
    }],
    'no-useless-backreference': 'error',
    'no-useless-call': 'error',
    'no-useless-catch': 'error',
    'no-useless-computed-key': 'error',
    'no-useless-concat': 'error',
    'no-useless-constructor': 'error',
    'no-useless-rename': 'error',
    'no-useless-return': 'error',
    'no-var': 'error',
    'object-shorthand': 'error',
    'one-var': ['error', 'never'],
    'prefer-arrow-callback': 'error',
    'prefer-const': ['error', {
      destructuring: 'all'
    }],
    'prefer-destructuring': ['error', {
      AssignmentExpression: {
        array: false,
        object: false
      },
      VariableDeclarator: {
        array: false,
        object: true
      }
    }],
    'prefer-exponentiation-operator': 'error',
    'prefer-numeric-literals': 'error',
    'prefer-object-spread': 'error',
    'prefer-template': 'error',
    'react-hooks/exhaustive-deps': 'error',
    'react/self-closing-comp': 'error',
    'require-await': 'error'
  }
}