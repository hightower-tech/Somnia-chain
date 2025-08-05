# Somnia Validator Monitor Bot - Complete Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Features](#features)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [Project Structure](#project-structure)
7. [Core Components](#core-components)
8. [Bot Commands](#bot-commands)
9. [Database Schema](#database-schema)
10. [Monitoring System](#monitoring-system)
11. [Internationalization](#internationalization)
12. [Error Handling](#error-handling)
13. [Logging System](#logging-system)
14. [Queue System](#queue-system)
15. [Caching](#caching)
16. [Admin Panel](#admin-panel)
17. [Security](#security)
18. [Development](#development)
19. [Deployment](#deployment)
20. [Troubleshooting](#troubleshooting)

## Overview

Somnia Validator Monitor Bot is a Telegram bot designed to monitor validators on the Somnia Network blockchain. It provides real-time monitoring, alerts, and detailed information about validator status, committee participation, and staking activities.

### Key Technologies
- **TypeScript** - Primary programming language
- **Node.js** - Runtime environment
- **Telegraf** - Telegram bot framework
- **Viem** - Ethereum/Web3 interaction library
- **SQLite** - Database for persistent storage
- **Winston** - Logging system
- **Bull** - Queue management (Redis-based)
- **i18n** - Internationalization support
- **node-cache** - In-memory caching

## Architecture

The bot follows a modular architecture with clear separation of concerns:

```
┌─────────────────┐     ┌──────────────┐     ┌─────────────────┐
│  Telegram API   │────▶│   Bot Core   │────▶│  Blockchain RPC │
└─────────────────┘     └──────┬───────┘     └─────────────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
              ┌─────▼─────┐         ┌────▼────┐
              │  Database │         │  Cache  │
              └───────────┘         └─────────┘
```

### Core Modules
1. **Bot Core** (`bot.ts`) - Main bot logic and command handlers
2. **Blockchain Service** (`blockchainService.ts`) - Somnia blockchain interaction
3. **Monitoring Service** (`monitoring.ts`) - Periodic validator monitoring
4. **Database Layer** (`database.ts`) - SQLite operations
5. **Configuration** (`config/index.ts`) - Centralized configuration management

## Features

### User Features
- **Validator Monitoring** - Real-time tracking of validator status
- **Committee Alerts** - Notifications for committee selection changes
- **Multi-language Support** - 5 languages (EN, RU, ZH, JA, ES)
- **Detailed Statistics** - Comprehensive validator information
- **Subscription Management** - Easy subscribe/unsubscribe system

### Technical Features
- **Graceful Shutdown** - Proper cleanup on termination
- **Error Recovery** - Retry mechanisms with exponential backoff
- **Queue System** - Asynchronous command processing
- **Caching Layer** - Performance optimization
- **Structured Logging** - Detailed logs with rotation
- **Admin Panel** - Advanced management features

## Installation

### Prerequisites
- Node.js v18+ 
- npm or yarn
- Redis (optional, for queue system)
- SQLite3

### Steps
```bash
# Clone the repository
git clone https://github.com/your-repo/somnia-validator-bot.git
cd somnia-validator-bot

# Install dependencies
npm install

# Copy environment example
cp .env.example .env

# Edit .env with your configuration
nano .env

# Build the project
npm run build

# Start the bot
npm start
```

## Configuration

### Environment Variables

The bot uses environment variables for configuration. All settings are defined in `.env` file:

#### Bot Configuration
- `BOT_TOKEN` - Telegram bot token from @BotFather
- `TELEGRAM_ADMIN_IDS` - Comma-separated list of admin user IDs
- `ALLOWED_USERS_PATH` - Path to allowed users JSON file

#### Blockchain Configuration
- `RPC_URL` - Somnia network RPC endpoint
- `NODE_COMMITTEE_CONTRACT_ADDRESS` - Committee contract address
- `CHAIN_ID` - Somnia network chain ID (default: 50311)

#### Monitoring Configuration
- `MONITORING_INTERVAL_SEC` - Validator check interval (default: 300)
- `COMMITTEE_MONITORING_INTERVAL_SEC` - Committee check interval (default: 60)

#### Database Configuration
- `DATABASE_PATH` - SQLite database file path

#### Display Configuration
- `DISPLAY_STAKE_DETAILS` - Show staking information (true/false)
- `DISPLAY_REWARDS` - Show rewards information (true/false)
- `DISPLAY_PERFORMANCE` - Show performance metrics (true/false)

#### Redis Configuration (Optional)
- `REDIS_HOST` - Redis server host
- `REDIS_PORT` - Redis server port
- `REDIS_PASSWORD` - Redis password (if required)

### Configuration Module

The centralized configuration is managed in `src/config/index.ts`:

```typescript
interface Config {
  bot: {
    token: string;
    adminIds: number[];
    allowedUsersPath: string;
  };
  blockchain: {
    rpcUrl: string;
    nodeCommitteeContract: string;
    chainId: number;
    // ... more settings
  };
  monitoring: {
    intervalSeconds: number;
    committeeIntervalSeconds: number;
  };
  // ... other sections
}
```

## Project Structure

```
somnibot/
├── src/
│   ├── config/
│   │   └── index.ts          # Centralized configuration
│   ├── commands/             # Command handlers
│   │   ├── base.command.ts   # Base command class
│   │   ├── start.command.ts  # /start command
│   │   ├── help.command.ts   # /help command
│   │   └── ...
│   ├── services/             # Business logic services
│   │   ├── queue.service.ts  # Bull queue management
│   │   ├── cache.service.ts  # Caching layer
│   │   ├── i18n.service.ts   # Internationalization
│   │   └── conversation.service.ts
│   ├── middleware/           # Bot middleware
│   │   └── error.middleware.ts
│   ├── utils/                # Utility functions
│   │   ├── logger.ts         # Winston logger setup
│   │   ├── retry.ts          # Retry logic
│   │   ├── shutdown.ts       # Graceful shutdown
│   │   └── helpers.ts        # Helper functions
│   ├── bot.ts                # Main bot file
│   ├── blockchainService.ts  # Blockchain interaction
│   ├── monitoring.ts         # Monitoring logic
│   ├── database.ts           # Database operations
│   ├── stats.ts              # Statistics tracking
│   └── adminPanel.ts         # Admin functionality
├── locales/                  # Translation files
│   ├── en.json
│   ├── ru.json
│   ├── zh.json
│   ├── ja.json
│   └── es.json
├── logs/                     # Log files (auto-created)
├── dist/                     # Compiled JavaScript
├── .env                      # Environment variables
├── .env.example              # Example configuration
├── tsconfig.json             # TypeScript configuration
├── package.json              # Dependencies
└── README.md                 # Basic documentation
```

## Core Components

### Bot Core (`bot.ts`)

The main bot file handles:
- Command registration and handling
- Message processing
- Callback queries
- User authentication
- State management

Key features:
- Modular command system
- Conversation state tracking
- Admin command separation
- Multi-language command descriptions

### Blockchain Service (`blockchainService.ts`)

Interfaces with Somnia blockchain:
- Validator data fetching
- Committee status checking
- Contract interactions
- Event monitoring

Key functions:
```typescript
getValidatorData(address: string): Promise<ValidatorDetails>
getCommitteeStatus(address: string): Promise<CommitteeInfo>
getStakeDetails(validatorId: bigint): Promise<StakeInfo>
```

### Monitoring Service (`monitoring.ts`)

Handles periodic checks:
- Validator status monitoring
- Committee participation tracking
- Alert generation
- Database updates

Features:
- Separate intervals for different checks
- Efficient batch processing
- Error recovery
- Graceful shutdown support

### Database Layer (`database.ts`)

SQLite database management:
- User subscriptions
- Validator states
- Alert history
- Statistics

Key tables:
- `subscriptions` - User-validator mappings
- `validator_states` - Cached validator data
- `bot_metrics` - Usage statistics

## Bot Commands

### User Commands

#### `/start`
- Shows welcome message
- Displays bot capabilities
- Available in all languages

#### `/subscribe`
- Subscribe to validator monitoring
- Syntax: `/subscribe` then send validator address
- Validates Ethereum addresses
- Prevents duplicate subscriptions

#### `/unsubscribe`
- Remove validator subscription
- Syntax: `/unsubscribe` then send validator address
- Confirms removal

#### `/status`
- View all active subscriptions
- Shows validator details:
  - Committee status (current/next epoch)
  - Moniker and commission
  - Total stake and delegators
  - Performance metrics
  - Rewards information

#### `/language`
- Change bot interface language
- Supported: English, Russian, Chinese, Japanese, Spanish
- Persists user preference

#### `/help`
- Shows command reference
- Admin users see admin panel

### Admin Commands

Accessed through `/help` for admin users:

#### User Management
- View all bot users
- Search users by ID
- Send messages to users
- View user statistics

#### Monitoring Control
- Force refresh validators
- View monitoring status
- Check error logs

#### System Information
- Bot statistics
- Database metrics
- Performance data
- RPC endpoint status

## Database Schema

### Tables

#### `subscriptions`
```sql
CREATE TABLE subscriptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    chat_id INTEGER NOT NULL,
    node_address TEXT NOT NULL,
    network TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(chat_id, node_address)
);
```

#### `validator_states`
```sql
CREATE TABLE validator_states (
    node_address TEXT PRIMARY KEY,
    data TEXT NOT NULL,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### `bot_metrics`
```sql
CREATE TABLE bot_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    total_users INTEGER DEFAULT 0,
    total_commands INTEGER DEFAULT 0,
    total_subscriptions INTEGER DEFAULT 0,
    total_api_calls INTEGER DEFAULT 0,
    uptime_seconds INTEGER DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Monitoring System

### Validator Monitoring
- Runs every 5 minutes (configurable)
- Checks all subscribed validators
- Updates database cache
- Generates alerts for changes

### Committee Monitoring
- Runs every 60 seconds (configurable)
- Tracks committee participation
- Sends immediate alerts on changes
- Separate from main monitoring for responsiveness

### Alert Types
1. **Committee Selection** - Validator selected/removed from committee
2. **Status Changes** - Active/inactive transitions
3. **Performance Alerts** - Significant metric changes

## Internationalization

### Supported Languages
- English (en)
- Russian (ru) 
- Chinese (zh)
- Japanese (ja)
- Spanish (es)

### Implementation
- Uses `i18n` library
- JSON-based translations
- User preference storage
- Fallback to English

### Translation Structure
```json
{
  "welcome": {
    "title": "Welcome message",
    "description": "Bot description"
  },
  "commands": {
    "subscribe": {
      "prompt": "Send validator address",
      "success": "Successfully subscribed"
    }
  }
}
```

## Error Handling

### Retry Mechanism
- Exponential backoff for failed requests
- Configurable retry attempts
- Maximum delay caps
- Decorator support

### Error Middleware
- Catches all bot errors
- Logs with unique error IDs
- User-friendly error messages
- Prevents bot crashes

### Error Types
1. **Network Errors** - RPC timeouts, connection issues
2. **Validation Errors** - Invalid addresses, data
3. **Database Errors** - SQLite issues
4. **Telegram API Errors** - Rate limits, network

## Logging System

### Winston Configuration
- Console output with colors
- Daily rotating file logs
- Separate error logs
- Configurable log levels

### Log Files
- `logs/combined-YYYY-MM-DD.log` - All logs
- `logs/error-YYYY-MM-DD.log` - Errors only
- Automatic rotation and cleanup
- Maximum file size limits

### Child Loggers
- `blockchain` - Blockchain operations
- `monitoring` - Monitoring activities
- `database` - Database operations
- `queue` - Queue processing

## Queue System

### Bull Queues
- Command processing queue
- Notification queue
- Redis-based persistence
- Automatic retries

### Queue Features
- Priority support
- Delayed jobs
- Rate limiting
- Failed job handling
- Dashboard support

### Configuration
```javascript
{
  removeOnComplete: 100,  // Keep last 100 completed
  removeOnFail: 50,       // Keep last 50 failed
  attempts: 3,            // Retry 3 times
  backoff: {
    type: 'exponential',
    delay: 2000           // Start with 2s delay
  }
}
```

## Caching

### Cache Layers
1. **Validator Cache** - 5 minute TTL
2. **Committee Cache** - 30 second TTL
3. **Stats Cache** - 1 hour TTL

### Cache Service
- Automatic expiration
- Memory efficient
- Hit/miss tracking
- Decorator support

### Usage
```typescript
@Cacheable('validator', (address) => address)
async getValidatorData(address: string) {
  // Automatically cached
}
```

## Admin Panel

### Features
- User management
- System statistics
- Direct messaging
- Monitoring control
- Performance metrics

### Access Control
- Admin IDs in environment
- Secure command handling
- Activity logging

### Admin Flows
1. **User Search** - Find users by ID
2. **Broadcast** - Message all users
3. **Statistics** - View bot metrics
4. **Maintenance** - System controls

## Security

### Access Control
- Telegram user ID validation
- Admin-only commands
- Allowed users list (optional)

### Data Protection
- Environment variables for secrets
- No sensitive data in logs
- Secure RPC connections

### Best Practices
- Input validation
- SQL injection prevention
- Rate limiting
- Error message sanitization

## Development

### Setup Development Environment
```bash
# Install dependencies
npm install

# Set up pre-commit hooks
npm run prepare

# Run in development mode
npm run dev
```

### Code Style
- TypeScript strict mode
- ESLint configuration
- Prettier formatting
- Consistent naming conventions

### Testing
```bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
```

### Building
```bash
# Build for production
npm run build

# Clean build
rm -rf dist && npm run build
```

## Deployment

### Production Checklist
1. Set production environment variables
2. Configure proper RPC endpoints
3. Set up Redis (optional)
4. Configure log rotation
5. Set up process manager (PM2)
6. Configure monitoring
7. Set up backups

### PM2 Configuration
```javascript
module.exports = {
  apps: [{
    name: 'somnia-bot',
    script: './dist/bot.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production'
    }
  }]
}
```

### Docker Support
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
CMD ["node", "dist/bot.js"]
```

## Troubleshooting

### Common Issues

#### Bot Not Starting
- Check BOT_TOKEN is valid
- Verify database permissions
- Check log files for errors

#### No Blockchain Data
- Verify RPC_URL is accessible
- Check contract addresses
- Monitor RPC rate limits

#### Database Errors
- Check file permissions
- Verify disk space
- Run database integrity check

#### Redis Connection Failed
- Redis is optional
- Check REDIS_HOST and REDIS_PORT
- Verify Redis is running

### Debug Mode
Set environment variables:
```bash
NODE_ENV=development
LOG_LEVEL=debug
```

### Health Checks
- `/health` endpoint (if enabled)
- Monitoring metrics
- Log file analysis
- Database queries

### Performance Optimization
1. Enable caching
2. Optimize database queries
3. Use queue system
4. Monitor memory usage
5. Set up proper indexes

## Maintenance

### Regular Tasks
1. **Log Rotation** - Automatic with Winston
2. **Database Cleanup** - Remove old states
3. **Cache Optimization** - Monitor hit rates
4. **Performance Review** - Check metrics

### Backup Strategy
- Daily database backups
- Configuration backups
- Log archival
- Disaster recovery plan

### Monitoring
- Uptime monitoring
- Error rate tracking
- Performance metrics
- User activity analysis

## API Reference

### Blockchain Service API

#### `getValidatorData(address: string)`
Returns complete validator information including stake, performance, and rewards.

#### `getCommitteeStatus(address: string)`
Returns current and next epoch committee participation status.

#### `checkIsNodeActive(address: string)`
Simple boolean check for validator active status.

### Database API

#### `subscribeUser(chatId, address, network)`
Creates new subscription for user.

#### `unsubscribeUser(chatId, address)`
Removes user subscription.

#### `getSubscriptionsByChatId(chatId)`
Returns all subscriptions for a user.

#### `saveValidatorState(address, data)`
Caches validator data in database.

### Bot Context Extensions

The bot extends Telegraf context with:
- `ctx.i18n` - Internationalization functions
- `ctx.session` - User session data
- Custom middleware additions

## Contributing

### Guidelines
1. Follow TypeScript best practices
2. Add appropriate logging
3. Update documentation
4. Test thoroughly
5. Submit pull requests

### Code Review Process
1. Automated checks (linting, types)
2. Manual code review
3. Testing verification
4. Documentation updates

## License

This project is licensed under the MIT License. See LICENSE file for details.

## Support

For issues and questions:
1. Check documentation
2. Review logs
3. Search existing issues
4. Create new issue with details

---

Built with ❤️ by [htw.tech](https://www.htw.tech/)
