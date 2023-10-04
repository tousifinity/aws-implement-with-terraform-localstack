const express = require('express');
const AWS = require('aws-sdk');

// Initialize AWS SDK with your LocalStack configuration
AWS.config.update({
    accessKeyId: 'test',
    secretAccessKey: 'test',
    region: 'us-east-1',
    endpoint: 'http://localhost:4566', // Adjust as needed for LocalStack
});

const dynamoDB = new AWS.DynamoDB.DocumentClient();
const app = express();
const port = 3000;

app.use(express.json());

// Create Item
app.post('/api/items', (req, res) => {
    const item = req.body;

    const params = {
        TableName: 'Tousif', // Update with your DynamoDB table name
        Item: item,
    };

    dynamoDB.put(params, (err) => {
        if (err) {
            console.error('Error creating item:', err);
            res.status(500).json({ error: 'Internal Server Error' });
        } else {
            res.status(201).json({ message: 'Item created successfully' });
        }
    });
});

// Get All Items
app.get('/api/items', (req, res) => {
    const params = {
        TableName: 'Tousif', // Update with your DynamoDB table name
    };

    dynamoDB.scan(params, (err, data) => {
        if (err) {
            console.error('Error fetching items:', err);
            res.status(500).json({ error: 'Internal Server Error' });
        } else {
            res.json(data.Items);
        }
    });
});

// Get Item by ID
app.get('/api/items/:id', (req, res) => {
    const id = req.params.id;

    const params = {
        TableName: 'Tousif', // Update with your DynamoDB table name
        Key: { id: id },
    };

    dynamoDB.get(params, (err, data) => {
        if (err) {
            console.error('Error fetching item:', err);
            res.status(500).json({ error: 'Internal Server Error' });
        } else if (!data.Item) {
            res.status(404).json({ error: 'Item not found' });
        } else {
            res.json(data.Item);
        }
    });
});

// Update Item by ID
app.put('/api/items/:id', (req, res) => {
    const id = req.params.id;
    const updatedItem = req.body;

    const params = {
        TableName: 'Tousif', // Update with your DynamoDB table name
        Key: { id: id },
        UpdateExpression: 'SET #data = :data',
        ExpressionAttributeNames: { '#data': 'data' },
        ExpressionAttributeValues: { ':data': updatedItem.data },
    };

    dynamoDB.update(params, (err) => {
        if (err) {
            console.error('Error updating item:', err);
            res.status(500).json({ error: 'Internal Server Error' });
        } else {
            res.json({ message: 'Item updated successfully' });
        }
    });
});

// Delete Item by ID
app.delete('/api/items/:id', (req, res) => {
    const id = req.params.id;

    const params = {
        TableName: 'Tousif', // Update with your DynamoDB table name
        Key: { id: id },
    };

    dynamoDB.delete(params, (err) => {
        if (err) {
            console.error('Error deleting item:', err);
            res.status(500).json({ error: 'Internal Server Error' });
        } else {
            res.json({ message: 'Item deleted successfully' });
        }
    });
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
