import './App.css';
import Layout from './components/layout/Layout.tsx';
import '../src/styles/colors.css';
import ContactPage from './components/pages/ContactPage.tsx';
import NotFoundPage from './components/pages/NotFoundPage.tsx';
import LoginPage from './components/pages/login_page/LoginPage.tsx';
import ResinPage from './components/pages/resin_page/ResinPage.tsx';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';

function App() {

  const router = createBrowserRouter([{
  path: '/',
  element: <LoginPage />,
  errorElement: <NotFoundPage />,
},
// ROUTER ISSUE. CLICK ON RESINS PAGE, THEN CLICK ON CONTACTS
{
  path: '/app',
  element: <Layout />,
  children: [
    {
      path: 'contact',
      element: <ContactPage />
    },
    {
      path: 'resin',
      element: <ResinPage />
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
