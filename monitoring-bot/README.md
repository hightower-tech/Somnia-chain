# Somnia Validator Monitor Bot

🤖 A powerful Telegram bot for monitoring validators on the Somnia Network blockchain with real-time alerts and multi-language support.

[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://telegram.org/)

## 🌟 Features

### Core Functionality
- **🔍 Real-time Monitoring** - Track validator status 24/7
- **🚨 Instant Alerts** - Get notified about committee changes and status updates
- **📊 Detailed Statistics** - View comprehensive validator information
- **🌐 Multi-language Support** - Available in English, Russian, Chinese, Japanese, and Spanish
- **⚡ High Performance** - Built-in caching and queue system for optimal speed

### Technical Features
- **💾 Persistent Storage** - SQLite database for reliable data storage
- **🔄 Auto-recovery** - Retry mechanisms with exponential backoff
- **📝 Structured Logging** - Detailed logs with automatic rotation
- **🛡️ Secure** - Admin-only commands and access control
- **🔧 Graceful Shutdown** - Clean termination without data loss

## 🚀 Quick Start

### Prerequisites
- Node.js v18+
- Telegram Bot Token (from [@BotFather](https://t.me/botfather))
- Somnia Network RPC endpoint

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-repo/somnia-validator-bot.git
cd somnia-validator-bot
```

2. **Install dependencies**
```bash
npm install
```

3. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your settings
```

4. **Build and start**
```bash
npm run build
npm start
```

## 📱 How to Use

### For Users

1. **Start the bot**
   - Find your bot on Telegram
   - Send `/start` to see the welcome message

2. **Subscribe to a validator**
   - Send `/subscribe`
   - Reply with the validator address (e.g., `0x...`)
   - Receive confirmation

3. **Check your subscriptions**
   - Send `/status` to see all your validators
   - Click on any validator for detailed info

4. **Change language**
   - Send `/language`
   - Select your preferred language

5. **Get help**
   - Send `/help` for command reference

### For Administrators

Administrators have access to additional features through the admin panel:
- User management
- System statistics
- Direct messaging
- Monitoring controls

## ⚙️ Configuration

### Essential Environment Variables

```env
# Bot Configuration
BOT_TOKEN=your_telegram_bot_token
TELEGRAM_ADMIN_IDS=123456789,987654321

# Blockchain Configuration
RPC_URL=https://your-somnia-rpc-endpoint
NODE_COMMITTEE_CONTRACT_ADDRESS=0x...

# Monitoring (optional)
MONITORING_INTERVAL_SEC=300
COMMITTEE_MONITORING_INTERVAL_SEC=60
```

See `.env.example` for all available options.

## 📋 Bot Commands

| Command | Description |
|---------|-------------|
| `/start` | Start the bot and see welcome message |
| `/subscribe` | Subscribe to validator alerts |
| `/unsubscribe` | Remove validator subscription |
| `/status` | View your active subscriptions |
| `/language` | Change interface language |
| `/help` | Display help message |

## 🏗️ Architecture

The bot is built with a modular architecture:

- **Bot Core** - Command handling and user interaction
- **Blockchain Service** - Somnia network communication
- **Monitoring Service** - Periodic validator checks
- **Database Layer** - SQLite for data persistence
- **Queue System** - Asynchronous task processing (Redis optional)
- **Cache Layer** - In-memory caching for performance

## 🌍 Internationalization

The bot supports multiple languages out of the box:
- 🇬🇧 English
- 🇷🇺 Russian
- 🇨🇳 Chinese
- 🇯🇵 Japanese
- 🇪🇸 Spanish

Language selection is persistent per user and affects all bot messages.

## 📊 Monitoring Details

The bot monitors validators for:
- Active/Inactive status changes
- Committee participation (current and next epoch)
- Staking information updates
- Performance metrics
- Reward distributions

Alerts are sent immediately when changes are detected.

## 🔒 Security

- Admin-only commands protected by user ID verification
- Environment variables for sensitive data
- Input validation for all user inputs
- Rate limiting and error handling

## 🛠️ Development

### Setup Development Environment
```bash
# Install dependencies
npm install

# Run in development mode
npm run dev

# Run tests
npm test
```

### Project Structure
```
src/
├── bot.ts              # Main bot file
├── config/             # Configuration management
├── commands/           # Command handlers
├── services/           # Business logic
├── utils/              # Utilities
└── locales/            # Translation files
```

## 📈 Performance

- **Caching**: Multi-level cache system reduces API calls
- **Queue System**: Asynchronous processing with Redis (optional)
- **Database Optimization**: Indexed queries for fast lookups
- **Graceful Shutdown**: Clean termination preserves data integrity

## 🚨 Troubleshooting

### Bot not starting?
- Verify `BOT_TOKEN` is correct
- Check database file permissions
- Review logs in `logs/` directory

### No blockchain data?
- Confirm RPC endpoint is accessible
- Check contract addresses
- Monitor RPC rate limits

### Redis errors?
- Redis is optional - bot works without it
- If using Redis, verify connection settings

## 📝 Documentation

- [Full Documentation (English)](./DOCUMENTATION.md)
- [Полная документация (Русский)](./DOCUMENTATION_RU.md)

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 Support

- Check the documentation
- Review existing issues
- Create a new issue with details
- Contact the development team

## 🙏 Acknowledgments

Built with ❤️ by [htw.tech](https://www.htw.tech/)

Special thanks to the Somnia Network community for their support and feedback.

---

**Note**: This bot is not officially affiliated with Somnia Network. Use at your own risk and always verify validator information through official channels.
