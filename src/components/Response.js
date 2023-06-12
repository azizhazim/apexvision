// Response.js
export function Response({ response }) {
    return (
        <div
            style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',  // added to align items in the center
                justifyContent: 'center',  // added to align items in the center
                fontSize: '16px',
                color: '#212121',
                margin: '20px 0',  // added margin to create space
            }}
        >
            <h2 style={{ marginBottom: '10px' }}>Apex AI Response</h2>
            <div>{response}</div>
        </div>
    );
}
