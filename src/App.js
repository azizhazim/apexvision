import { useState } from 'react';
import { Container } from './components/Container';
import { Button } from './components/Button';
import { Loader } from './components/Loader';
import { Response } from './components/Response';
import { Divider } from './components/Divider';

function App() {
    const [answer, setAnswer] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    const handleButtonPress = () => {
        setLoading(true);
        setAnswer(null);
        setError(null);

        chrome.runtime.sendMessage({ action: "get_chat_gpt_response" }, function (response) {
            if (chrome.runtime.lastError) {
                setError(chrome.runtime.lastError.message);
            } else if (response.error) {
                setError(response.error);
            } else {
                setAnswer(response.answer);
            }
            setLoading(false);
        });
    };

    return (
        <Container className="w-full h-full flex items-center justify-center">
            <div className="text-center">
                {loading ? <Loader /> : <Button onClick={handleButtonPress} />}
                {answer && <><Divider /><Response response={answer} /></>}
                {error && <p className="mt-8 text-lg text-red-500">{error}</p>}
            </div>
        </Container>
    );
}

export default App;
