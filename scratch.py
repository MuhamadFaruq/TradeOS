with open("lib/presentation/screens/add_trade_screen.dart", "r") as f:
    content = f.read()

# Add portfolio provider import
imports_old = "import '../../data/providers/trade_provider.dart';"
imports_new = "import '../../data/providers/trade_provider.dart';\nimport '../../data/providers/portfolio_provider.dart';"
content = content.replace(imports_old, imports_new)

# Find where Trade is created.
# Usually: final trade = Trade.create(
create_old = """      final trade = Trade.create(
        pair: pair,
        direction: direction,"""

create_new = """      final activePortfolioId = ref.read(activePortfolioIdProvider);
      
      final trade = Trade.create(
        pair: pair,
        direction: direction,
        portfolioId: activePortfolioId,"""

content = content.replace(create_old, create_new)

with open("lib/presentation/screens/add_trade_screen.dart", "w") as f:
    f.write(content)
