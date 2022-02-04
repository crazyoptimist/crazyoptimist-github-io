---
title: "Redux Setup in Your React Project - Personal Preference"
date: 2021-04-22T22:05:46-05:00
categories: ['javascript']
---
The first thing is to install libraries for redux, as you may guess:

```bash
npm install -S redux react-redux redux-logger reselect redux-persist
```

`redux-logger` is a redux middleware which is really really helpful in development, but it's up to you whether to use it or not.  
`reselect` is a memoization implementation for redux.  
`redux-persist` is for leveraging localStorage/sessionStorage browser APIs in redux.  

Assuming that you have the react project structured in your own way, I'd create a new folder named `redux` inside the `src/app` folder:

```bash
mkdir -p src/app/redux
```

For demonstration purposes, we gonna setup `user reducer`, which is specific to `user` domain.  
Create a `root reducer` and `store` first, though.  

```bash
# inside the 'redux' folder:
touch root-reducer.js store.js
```

Then create `user reducer`-related files:

```bash
# inside the 'redux' folder:
mkdir -p user
cd user
touch user.reducer.js user.types.js user.actions.js user.selectors.js
```

Overwhelming already? Nah~ it's not, let me explain what the files do.  

`user.reducer.js` is a file that contains real reducer, which can be called `CPU` of redux.  
`user.types.js` will be containing action types as variables(I'd call it mapping), which is a good convention in redux world.  
`user.actions.js` has real action definitions in it.  
`user.selectors.js` is for memoization which is a great concept for pure functions, and it's all about performance.  

Here is our `root-reducer.js` file:

```javascript
import { combineReducers } from 'redux';
import { persistReducer } from 'redux-persist';
import storage from 'redux-persist/lib/storage';

import userReducer from './user/user.reducer';
import cartReducer from './cart/cart.reducer'; // just ignore this, it's only for demonstration of redux-persist setup

const persistConfig = {
  key: 'root',
  storage,
  whitelist: ['cart']
};

const rootReducer = combineReducers({
  user: userReducer,
  cart: cartReducer,
});

export default persistReducer(persistConfig, rootReducer);
```

Here is our `store.js` file then:

```javascript
import { createStore, applyMiddleware } from 'redux';
import { persistStore } from 'redux-persist';
import logger from 'redux-logger';

import rootReducer from './root-reducer';

const middlewares = [];

if (process.env.NODE_ENV === 'development') {
  middlewares.push(logger);
}

const store = createStore(rootReducer, applyMiddleware(...middlewares));

const persistor = persistStore(store);

export { store, persistor };
```

`user.types.js` file:

```javascript
export const UserActionTypes = {
  SET_CURRENT_USER: 'SET_CURRENT_USER'
}
```

`user.reducer.js` file:

```javascript
import { UserActionTypes } from './user.types';

const INITIAL_STATE = {
  currentUser: null
}

const userReducer = (state=INITIAL_STATE, action) => {
  switch (action.type) {
    case UserActionTypes.SET_CURRENT_USER:
      return {
        ...state,
        currentUser: action.payload
      }
    default:
      return state;
  }
}

export default userReducer;
```

`user.actions.js` file:

```javascript
import { UserActionTypes } from './user.types';

export const setCurrentUser = user => ({
  type: UserActionTypes.SET_CURRENT_USER,
  payload: user
})
```

`user.selectors.js` file:

```javascript
import { createSelector } from 'reselect';

const selectUser = state => state.user;

export const selectCurrentUser = createSelector(
  [selectUser],
  (user) => user.currentUser
)
```

Phew ~ it's time to set it up in our `index.js` file:

```javascript
import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/integration/react';

import './index.scss';
import App from './App';
import { store, persistor } from './redux/store';

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <BrowserRouter>
        <PersistGate persistor={persistor}>
          <App />
        </PersistGate>
      </BrowserRouter>
    </Provider>
  </React.StrictMode>,
  document.getElementById('root')
);
```

Let's use our redux store in any component of our application finally:

```javascript
import React from 'react';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';

import { setCurrentUser } from './redux/user/user.actions';
import { selectCurrentUser } from './redux/user/user.selectors';

const YourComponent = props => {
  const { currentUser, setCurrentUser } = props;

  //Do something fantastic with the state and the dispatch!

  return (
    <div />
  );
}

const mapStateToProps = createStructuredSelector({
  currentUser: selectCurrentUser
});

const mapDispatchToProps = dispatch => ({
  setCurrentUser: user => dispatch(setCurrentUser(user))
});

export default connect(mapStateToProps, mapDispatchToProps)(YourComponent);
```

That's it. Once you setup the redux, it's pretty much repetitive task to use it in any corner of your application.  
Happy coding! 😎
