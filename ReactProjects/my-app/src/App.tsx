import './App.css';
import Layout from './components/layout/Layout.tsx';
import '../src/styles/colors.css';
import ContactPage from './components/pages/ContactPage.tsx';
import NotFoundPage from './components/pages/NotFoundPage.tsx';
import LoginPage from './components/pages/LoginPage.tsx';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';

function App() {

  const router = createBrowserRouter([{
  path: '/',
  element: <LoginPage />,
  errorElement: <NotFoundPage />,
},
{
  path: '/app',
  element: <Layout />,
  children: [
    {
      path: 'contact',
      element: <ContactPage />
    },
  ]
},
]);
  return (
    <div>
      <RouterProvider router={router}/>
    </div>
  );
}

export default App
