---
title: "How to Setup Eslint and Prettier With Git Precommit Hooks in React Typescript Project"
date: 2021-08-16T05:39:46-05:00
categories: ['javascript']
---
You should probably create a new react app with typescript using like so:

```bash
npx create-react-app my-app --template typescript
```

Now let's get started to setup eslint and prettier.  
Remove `eslintConfig` from `package.json`.  
Install `prettier` using these commands:  

```bash
yarn add --dev --exact prettier
yarn add --dev eslint-config-prettier eslint-plugin-prettier 
```

Create config files like this:

```bash
touch .eslintrc.js .eslintignore .prettierrc.js .prettierignore
```

Use same contents for both ignore files:

```
build
node_modules
.github
```

You can use cli `init` command for eslint and prettier config, but here's a ready-to-go scripts:

```javascript
// .eslintrc.js
module.exports = {
    env: {
        browser: true,
        es6: true,
        node: true,
    },
    extends: [
        'eslint:recommended',
        'plugin:react/recommended',
        'plugin:react-hooks/recommended',
        'plugin:prettier/recommended',
        'plugin:jsx-a11y/strict',
    ],
    parser: '@typescript-eslint/parser',
    parserOptions: {
        ecmaFeatures: {
            jsx: true,
        },
        ecmaVersion: 2020,
        sourceType: 'module',
    },
    plugins: ['react', 'jsx-a11y', '@typescript-eslint'],
    rules: {
        'react-hooks/exhaustive-deps': 'error',
        'no-var': 'error',
        'brace-style': 'error',
        'prefer-template': 'error',
        radix: 'error',
        'space-before-blocks': 'error',
        'import/prefer-default-export': 'off',
    },
    overrides: [
        {
            files: [
                '**/*.test.js',
                '**/*.test.jsx',
                '**/*.test.tsx',
                '**/*.spec.js',
                '**/*.spec.jsx',
                '**/*.spec.tsx',
            ],
            env: {
                jest: true,
            },
        },
    ],
};
```

```javascript
//.prettierrc.js
module.exports = {
    printWidth: 100,
    tabWidth: 2,
    singleQuote: true,
    semi: true,
    trailingComma: 'all',
    arrowParens: "always",
    overrides: [
        {
            files: '*.{js,jsx,tsx,ts,scss,json,html}',
            options: {
                tabWidth: 4,
            },
        },
    ],
};
```

Add these scripts to `package.json` file:

```
"lint": "eslint . --fix",
"format": "prettier . --write"
```

Now you are good to run `yarn lint` and `yarn format`.  

Let's setup git precommit hooks with `husky` and `lint-staged`.  
Install `lint-staged` first:

```bash
yarn add --dev lint-staged
```

Add these lines to your `package.json` file:

```
"lint-staged": {
    "*.{js,ts,tsx}": [
        "eslint --quiet --fix"
    ],
    "*.{json,md,html}": [
        "prettier --write"
    ]
}
```

Install and configure husky like so:

```bash
npx husky-init
yarn
npx husky add .husky/pre-commit "lint-staged"
```

That's pretty much it.  
Happy coding! :)  
