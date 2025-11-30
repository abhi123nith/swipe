# API Specification

This document describes the API endpoints used in the Swipe Products application.

## Base URL

```
https://app.getswipe.in/api/public
```

## Endpoints

### 1. Get Products

Retrieve a list of all products.

- **URL**: `/get`
- **Method**: `GET`
- **Headers**: None required
- **Body**: None
- **Response**: Array of product objects

#### Success Response

```json
[
  {
    "image": "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1619635829_Farm_FreshToAvatar_Logo-01.png",
    "price": 1694.91525424,
    "product_name": "Testing app",
    "product_type": "Product",
    "tax": 18.0
  },
  {
    "image": "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1619873597_WhatsApp_Image_2021-04-30_at_19.43.23.jpeg",
    "price": 84745.76271186,
    "product_name": "Testing Update",
    "product_type": "Service",
    "tax": 18.0
  }
]
```

#### Error Response

```json
{
  "error": "Error message"
}
```

### 2. Add Product

Add a new product to the system.

- **URL**: `/add`
- **Method**: `POST`
- **Content-Type**: `multipart/form-data`
- **Body Parameters**:
  - `product_name` (text, required): Name of the product
  - `product_type` (text, required): Type of the product (Product or Service)
  - `price` (text, required): Selling price of the product
  - `tax` (text, required): Tax rate for the product
  - `files[]` (file, optional): Product image (JPEG or PNG format)

#### Success Response

```json
{
  "message": "Product added Successfully!",
  "product_details": {
    "image": "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/...",
    "price": 100.0,
    "product_name": "New Product",
    "product_type": "Product",
    "tax": 18.0
  },
  "product_id": 2657,
  "success": true
}
```

#### Error Response

```json
{
  "message": "Error message",
  "success": false
}
```

## Data Models

### Product Object

| Field | Type | Description |
|-------|------|-------------|
| image | string (nullable) | URL of the product image |
| price | number | Selling price of the product |
| product_name | string | Name of the product |
| product_type | string | Type of the product (Product or Service) |
| tax | number | Tax rate for the product |

## Error Handling

All API responses should be checked for success status. Error responses will contain an error message that should be displayed to the user.

## Rate Limiting

There are no documented rate limits for these API endpoints. However, the application implements proper error handling for potential rate limiting responses.

## Security

All API requests are made over HTTPS for secure transmission of data.

## Implementation Notes

1. The application caches product images using the `cached_network_image` package to reduce bandwidth usage.
2. All network requests are made asynchronously to prevent UI blocking.
3. The application implements retry mechanisms for failed requests.
4. Offline functionality is provided using Hive local storage.