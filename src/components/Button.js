// Button.js
export function Button({ onClick }) {
    return (
        <button
            style={{
                display: 'block', // changed to block to allow auto margin
                marginLeft: 'auto', 
                marginRight: 'auto', 
                marginTop: '20px', // extra space at the top
                alignItems: 'center',
                borderRadius: '5px',
                border: '1px solid #00C853',
                backgroundColor: '#00C853',
                padding: '10px',
                color: '#fff',
                boxShadow: '0px 1px 3px rgba(0,0,0,0.3)',
                fontSize: '16px',
                cursor: 'pointer',
                outline: 'none'
            }}
            onClick={onClick}
        >
            Get Answer
        </button>
    );
}
