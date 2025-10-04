import { Link } from 'react-router-dom';


export default function NotFoundPage() {

    return (
        <div>
            Error: Go Back 
            {/* Use Link instead of a tag
                This prevents page refresh and uses client-side routing */}
            <Link to="/app">Home</Link>
        </div>
    )
}