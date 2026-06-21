// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTradeCollection on Isar {
  IsarCollection<Trade> get trades => this.collection();
}

const TradeSchema = CollectionSchema(
  name: r'Trade',
  id: 4394246318675225554,
  properties: {
    r'afterExitScreenshots': PropertySchema(
      id: 0,
      name: r'afterExitScreenshots',
      type: IsarType.stringList,
    ),
    r'amount': PropertySchema(
      id: 1,
      name: r'amount',
      type: IsarType.double,
    ),
    r'beforeEntryScreenshots': PropertySchema(
      id: 2,
      name: r'beforeEntryScreenshots',
      type: IsarType.stringList,
    ),
    r'brokenRule': PropertySchema(
      id: 3,
      name: r'brokenRule',
      type: IsarType.string,
    ),
    r'commission': PropertySchema(
      id: 4,
      name: r'commission',
      type: IsarType.double,
    ),
    r'confidence': PropertySchema(
      id: 5,
      name: r'confidence',
      type: IsarType.long,
    ),
    r'cvd': PropertySchema(
      id: 6,
      name: r'cvd',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 7,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'direction': PropertySchema(
      id: 8,
      name: r'direction',
      type: IsarType.byte,
      enumMap: _TradedirectionEnumValueMap,
    ),
    r'durationHours': PropertySchema(
      id: 9,
      name: r'durationHours',
      type: IsarType.long,
    ),
    r'durationMinutes': PropertySchema(
      id: 10,
      name: r'durationMinutes',
      type: IsarType.long,
    ),
    r'emotion': PropertySchema(
      id: 11,
      name: r'emotion',
      type: IsarType.string,
    ),
    r'entryPrice': PropertySchema(
      id: 12,
      name: r'entryPrice',
      type: IsarType.double,
    ),
    r'exitPrice': PropertySchema(
      id: 13,
      name: r'exitPrice',
      type: IsarType.double,
    ),
    r'highPrice': PropertySchema(
      id: 14,
      name: r'highPrice',
      type: IsarType.double,
    ),
    r'isLong': PropertySchema(
      id: 15,
      name: r'isLong',
      type: IsarType.bool,
    ),
    r'leverage': PropertySchema(
      id: 16,
      name: r'leverage',
      type: IsarType.double,
    ),
    r'lowPrice': PropertySchema(
      id: 17,
      name: r'lowPrice',
      type: IsarType.double,
    ),
    r'notes': PropertySchema(
      id: 18,
      name: r'notes',
      type: IsarType.string,
    ),
    r'pair': PropertySchema(
      id: 19,
      name: r'pair',
      type: IsarType.string,
    ),
    r'pnl': PropertySchema(
      id: 20,
      name: r'pnl',
      type: IsarType.double,
    ),
    r'pnlPercentage': PropertySchema(
      id: 21,
      name: r'pnlPercentage',
      type: IsarType.double,
    ),
    r'riskRewardRatio': PropertySchema(
      id: 22,
      name: r'riskRewardRatio',
      type: IsarType.double,
    ),
    r'session': PropertySchema(
      id: 23,
      name: r'session',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 24,
      name: r'status',
      type: IsarType.byte,
      enumMap: _TradestatusEnumValueMap,
    ),
    r'stopLossPrice': PropertySchema(
      id: 25,
      name: r'stopLossPrice',
      type: IsarType.double,
    ),
    r'strategy': PropertySchema(
      id: 26,
      name: r'strategy',
      type: IsarType.string,
    ),
    r'swap': PropertySchema(
      id: 27,
      name: r'swap',
      type: IsarType.double,
    ),
    r'takeProfitPrice': PropertySchema(
      id: 28,
      name: r'takeProfitPrice',
      type: IsarType.double,
    ),
    r'totalVolume': PropertySchema(
      id: 29,
      name: r'totalVolume',
      type: IsarType.double,
    ),
    r'volumeImbalance': PropertySchema(
      id: 30,
      name: r'volumeImbalance',
      type: IsarType.double,
    ),
    r'wasRuleBroken': PropertySchema(
      id: 31,
      name: r'wasRuleBroken',
      type: IsarType.bool,
    )
  },
  estimateSize: _tradeEstimateSize,
  serialize: _tradeSerialize,
  deserialize: _tradeDeserialize,
  deserializeProp: _tradeDeserializeProp,
  idName: r'id',
  indexes: {
    r'pair': IndexSchema(
      id: -2280073220056032088,
      name: r'pair',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pair',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tradeGetId,
  getLinks: _tradeGetLinks,
  attach: _tradeAttach,
  version: '3.1.0+1',
);

int _tradeEstimateSize(
  Trade object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.afterExitScreenshots;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.beforeEntryScreenshots;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.brokenRule;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.emotion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.pair.length * 3;
  {
    final value = object.session;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.strategy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _tradeSerialize(
  Trade object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.afterExitScreenshots);
  writer.writeDouble(offsets[1], object.amount);
  writer.writeStringList(offsets[2], object.beforeEntryScreenshots);
  writer.writeString(offsets[3], object.brokenRule);
  writer.writeDouble(offsets[4], object.commission);
  writer.writeLong(offsets[5], object.confidence);
  writer.writeDouble(offsets[6], object.cvd);
  writer.writeDateTime(offsets[7], object.date);
  writer.writeByte(offsets[8], object.direction.index);
  writer.writeLong(offsets[9], object.durationHours);
  writer.writeLong(offsets[10], object.durationMinutes);
  writer.writeString(offsets[11], object.emotion);
  writer.writeDouble(offsets[12], object.entryPrice);
  writer.writeDouble(offsets[13], object.exitPrice);
  writer.writeDouble(offsets[14], object.highPrice);
  writer.writeBool(offsets[15], object.isLong);
  writer.writeDouble(offsets[16], object.leverage);
  writer.writeDouble(offsets[17], object.lowPrice);
  writer.writeString(offsets[18], object.notes);
  writer.writeString(offsets[19], object.pair);
  writer.writeDouble(offsets[20], object.pnl);
  writer.writeDouble(offsets[21], object.pnlPercentage);
  writer.writeDouble(offsets[22], object.riskRewardRatio);
  writer.writeString(offsets[23], object.session);
  writer.writeByte(offsets[24], object.status.index);
  writer.writeDouble(offsets[25], object.stopLossPrice);
  writer.writeString(offsets[26], object.strategy);
  writer.writeDouble(offsets[27], object.swap);
  writer.writeDouble(offsets[28], object.takeProfitPrice);
  writer.writeDouble(offsets[29], object.totalVolume);
  writer.writeDouble(offsets[30], object.volumeImbalance);
  writer.writeBool(offsets[31], object.wasRuleBroken);
}

Trade _tradeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Trade();
  object.afterExitScreenshots = reader.readStringList(offsets[0]);
  object.amount = reader.readDouble(offsets[1]);
  object.beforeEntryScreenshots = reader.readStringList(offsets[2]);
  object.brokenRule = reader.readStringOrNull(offsets[3]);
  object.commission = reader.readDouble(offsets[4]);
  object.confidence = reader.readLongOrNull(offsets[5]);
  object.cvd = reader.readDoubleOrNull(offsets[6]);
  object.date = reader.readDateTime(offsets[7]);
  object.direction =
      _TradedirectionValueEnumMap[reader.readByteOrNull(offsets[8])] ??
          TradeDirection.long;
  object.durationHours = reader.readLongOrNull(offsets[9]);
  object.durationMinutes = reader.readLongOrNull(offsets[10]);
  object.emotion = reader.readStringOrNull(offsets[11]);
  object.entryPrice = reader.readDouble(offsets[12]);
  object.exitPrice = reader.readDoubleOrNull(offsets[13]);
  object.highPrice = reader.readDoubleOrNull(offsets[14]);
  object.id = id;
  object.leverage = reader.readDouble(offsets[16]);
  object.lowPrice = reader.readDoubleOrNull(offsets[17]);
  object.notes = reader.readStringOrNull(offsets[18]);
  object.pair = reader.readString(offsets[19]);
  object.pnl = reader.readDouble(offsets[20]);
  object.pnlPercentage = reader.readDouble(offsets[21]);
  object.riskRewardRatio = reader.readDoubleOrNull(offsets[22]);
  object.session = reader.readStringOrNull(offsets[23]);
  object.status =
      _TradestatusValueEnumMap[reader.readByteOrNull(offsets[24])] ??
          TradeStatus.won;
  object.stopLossPrice = reader.readDoubleOrNull(offsets[25]);
  object.strategy = reader.readStringOrNull(offsets[26]);
  object.swap = reader.readDouble(offsets[27]);
  object.takeProfitPrice = reader.readDoubleOrNull(offsets[28]);
  object.totalVolume = reader.readDoubleOrNull(offsets[29]);
  object.volumeImbalance = reader.readDoubleOrNull(offsets[30]);
  object.wasRuleBroken = reader.readBool(offsets[31]);
  return object;
}

P _tradeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (_TradedirectionValueEnumMap[reader.readByteOrNull(offset)] ??
          TradeDirection.long) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readDoubleOrNull(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readDoubleOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (reader.readDoubleOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (_TradestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          TradeStatus.won) as P;
    case 25:
      return (reader.readDoubleOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readDouble(offset)) as P;
    case 28:
      return (reader.readDoubleOrNull(offset)) as P;
    case 29:
      return (reader.readDoubleOrNull(offset)) as P;
    case 30:
      return (reader.readDoubleOrNull(offset)) as P;
    case 31:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TradedirectionEnumValueMap = {
  'long': 0,
  'short': 1,
};
const _TradedirectionValueEnumMap = {
  0: TradeDirection.long,
  1: TradeDirection.short,
};
const _TradestatusEnumValueMap = {
  'won': 0,
  'lost': 1,
  'breakEven': 2,
  'pending': 3,
  'open': 4,
};
const _TradestatusValueEnumMap = {
  0: TradeStatus.won,
  1: TradeStatus.lost,
  2: TradeStatus.breakEven,
  3: TradeStatus.pending,
  4: TradeStatus.open,
};

Id _tradeGetId(Trade object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tradeGetLinks(Trade object) {
  return [];
}

void _tradeAttach(IsarCollection<dynamic> col, Id id, Trade object) {
  object.id = id;
}

extension TradeQueryWhereSort on QueryBuilder<Trade, Trade, QWhere> {
  QueryBuilder<Trade, Trade, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhere> anyPair() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'pair'),
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension TradeQueryWhere on QueryBuilder<Trade, Trade, QWhereClause> {
  QueryBuilder<Trade, Trade, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairEqualTo(String pair) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pair',
        value: [pair],
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairNotEqualTo(String pair) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pair',
              lower: [],
              upper: [pair],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pair',
              lower: [pair],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pair',
              lower: [pair],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pair',
              lower: [],
              upper: [pair],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairGreaterThan(
    String pair, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pair',
        lower: [pair],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairLessThan(
    String pair, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pair',
        lower: [],
        upper: [pair],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairBetween(
    String lowerPair,
    String upperPair, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pair',
        lower: [lowerPair],
        includeLower: includeLower,
        upper: [upperPair],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairStartsWith(
      String PairPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pair',
        lower: [PairPrefix],
        upper: ['$PairPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pair',
        value: [''],
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> pairIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'pair',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'pair',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'pair',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'pair',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TradeQueryFilter on QueryBuilder<Trade, Trade, QFilterCondition> {
  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'afterExitScreenshots',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'afterExitScreenshots',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afterExitScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'afterExitScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'afterExitScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'afterExitScreenshots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'afterExitScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'afterExitScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'afterExitScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'afterExitScreenshots',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afterExitScreenshots',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'afterExitScreenshots',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'afterExitScreenshots',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'afterExitScreenshots',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'afterExitScreenshots',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'afterExitScreenshots',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'afterExitScreenshots',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      afterExitScreenshotsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'afterExitScreenshots',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beforeEntryScreenshots',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beforeEntryScreenshots',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beforeEntryScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beforeEntryScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beforeEntryScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beforeEntryScreenshots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'beforeEntryScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'beforeEntryScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'beforeEntryScreenshots',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'beforeEntryScreenshots',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beforeEntryScreenshots',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'beforeEntryScreenshots',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beforeEntryScreenshots',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beforeEntryScreenshots',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beforeEntryScreenshots',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beforeEntryScreenshots',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beforeEntryScreenshots',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition>
      beforeEntryScreenshotsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beforeEntryScreenshots',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'brokenRule',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'brokenRule',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brokenRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'brokenRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'brokenRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'brokenRule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'brokenRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'brokenRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'brokenRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'brokenRule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brokenRule',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> brokenRuleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'brokenRule',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> commissionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commission',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> commissionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commission',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> commissionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commission',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> commissionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commission',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> confidenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confidence',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> confidenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confidence',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> confidenceEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> confidenceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> confidenceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> confidenceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> cvdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cvd',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> cvdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cvd',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> cvdEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cvd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> cvdGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cvd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> cvdLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cvd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> cvdBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cvd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> directionEqualTo(
      TradeDirection value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'direction',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> directionGreaterThan(
    TradeDirection value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'direction',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> directionLessThan(
    TradeDirection value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'direction',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> directionBetween(
    TradeDirection lower,
    TradeDirection upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'direction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationHoursIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationHours',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationHoursIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationHours',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationHoursEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationHours',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationHoursGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationHours',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationHoursLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationHours',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationHoursBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationMinutes',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationMinutes',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationMinutesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> durationMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emotion',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emotion',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emotion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emotion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emotion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emotion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotion',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> emotionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emotion',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> entryPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> entryPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> entryPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> entryPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> exitPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exitPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> exitPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exitPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> exitPriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> exitPriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> exitPriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> exitPriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exitPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> highPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'highPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> highPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'highPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> highPriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> highPriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> highPriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> highPriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> isLongEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLong',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> leverageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> leverageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> leverageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> leverageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leverage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> lowPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lowPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> lowPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lowPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> lowPriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> lowPriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lowPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> lowPriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lowPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> lowPriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lowPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pair',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pair',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pair',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pair',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pair',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pair',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pair',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pair',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pair',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pairIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pair',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pnl',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pnl',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pnl',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pnl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pnlPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pnlPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pnlPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> pnlPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pnlPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> riskRewardRatioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'riskRewardRatio',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> riskRewardRatioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'riskRewardRatio',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> riskRewardRatioEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'riskRewardRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> riskRewardRatioGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'riskRewardRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> riskRewardRatioLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'riskRewardRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> riskRewardRatioBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'riskRewardRatio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'session',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'session',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'session',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'session',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'session',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> sessionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'session',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> statusEqualTo(
      TradeStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> statusGreaterThan(
    TradeStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> statusLessThan(
    TradeStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> statusBetween(
    TradeStatus lower,
    TradeStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> stopLossPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stopLossPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> stopLossPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stopLossPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> stopLossPriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stopLossPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> stopLossPriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stopLossPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> stopLossPriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stopLossPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> stopLossPriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stopLossPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'strategy',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'strategy',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strategy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'strategy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'strategy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'strategy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'strategy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'strategy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'strategy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'strategy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strategy',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> strategyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'strategy',
        value: '',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> swapEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'swap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> swapGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'swap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> swapLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'swap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> swapBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'swap',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> takeProfitPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'takeProfitPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> takeProfitPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'takeProfitPrice',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> takeProfitPriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'takeProfitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> takeProfitPriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'takeProfitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> takeProfitPriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'takeProfitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> takeProfitPriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'takeProfitPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> totalVolumeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalVolume',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> totalVolumeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalVolume',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> totalVolumeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> totalVolumeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> totalVolumeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> totalVolumeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> volumeImbalanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'volumeImbalance',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> volumeImbalanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'volumeImbalance',
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> volumeImbalanceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volumeImbalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> volumeImbalanceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'volumeImbalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> volumeImbalanceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'volumeImbalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> volumeImbalanceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'volumeImbalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trade, Trade, QAfterFilterCondition> wasRuleBrokenEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasRuleBroken',
        value: value,
      ));
    });
  }
}

extension TradeQueryObject on QueryBuilder<Trade, Trade, QFilterCondition> {}

extension TradeQueryLinks on QueryBuilder<Trade, Trade, QFilterCondition> {}

extension TradeQuerySortBy on QueryBuilder<Trade, Trade, QSortBy> {
  QueryBuilder<Trade, Trade, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByBrokenRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brokenRule', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByBrokenRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brokenRule', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByCommission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commission', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByCommissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commission', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByCvd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvd', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByCvdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvd', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDirection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDirectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByEmotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByEmotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByEntryPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByEntryPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByExitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByExitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByHighPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByHighPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByIsLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLong', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByIsLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLong', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByLeverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leverage', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByLeverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leverage', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByLowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByLowPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByPair() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pair', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByPairDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pair', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByPnl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnl', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByPnlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnl', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByPnlPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnlPercentage', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByPnlPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnlPercentage', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByRiskRewardRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskRewardRatio', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByRiskRewardRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskRewardRatio', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByStopLossPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stopLossPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByStopLossPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stopLossPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByStrategy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByStrategyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortBySwap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swap', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortBySwapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swap', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByTakeProfitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takeProfitPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByTakeProfitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takeProfitPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByVolumeImbalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeImbalance', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByVolumeImbalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeImbalance', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByWasRuleBroken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRuleBroken', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> sortByWasRuleBrokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRuleBroken', Sort.desc);
    });
  }
}

extension TradeQuerySortThenBy on QueryBuilder<Trade, Trade, QSortThenBy> {
  QueryBuilder<Trade, Trade, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByBrokenRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brokenRule', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByBrokenRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brokenRule', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByCommission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commission', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByCommissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commission', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByCvd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvd', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByCvdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvd', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDirection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDirectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByEmotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByEmotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByEntryPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByEntryPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByExitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByExitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByHighPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByHighPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByIsLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLong', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByIsLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLong', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByLeverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leverage', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByLeverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leverage', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByLowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByLowPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByPair() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pair', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByPairDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pair', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByPnl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnl', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByPnlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnl', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByPnlPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnlPercentage', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByPnlPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pnlPercentage', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByRiskRewardRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskRewardRatio', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByRiskRewardRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskRewardRatio', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByStopLossPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stopLossPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByStopLossPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stopLossPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByStrategy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByStrategyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strategy', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenBySwap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swap', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenBySwapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swap', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByTakeProfitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takeProfitPrice', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByTakeProfitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takeProfitPrice', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByVolumeImbalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeImbalance', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByVolumeImbalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeImbalance', Sort.desc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByWasRuleBroken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRuleBroken', Sort.asc);
    });
  }

  QueryBuilder<Trade, Trade, QAfterSortBy> thenByWasRuleBrokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRuleBroken', Sort.desc);
    });
  }
}

extension TradeQueryWhereDistinct on QueryBuilder<Trade, Trade, QDistinct> {
  QueryBuilder<Trade, Trade, QDistinct> distinctByAfterExitScreenshots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'afterExitScreenshots');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByBeforeEntryScreenshots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beforeEntryScreenshots');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByBrokenRule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'brokenRule', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByCommission() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commission');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByCvd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cvd');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByDirection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'direction');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationHours');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMinutes');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByEmotion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByEntryPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryPrice');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByExitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exitPrice');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByHighPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highPrice');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByIsLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLong');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByLeverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leverage');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByLowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowPrice');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByPair(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pair', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByPnl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pnl');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByPnlPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pnlPercentage');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByRiskRewardRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'riskRewardRatio');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctBySession(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'session', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByStopLossPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stopLossPrice');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByStrategy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strategy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctBySwap() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'swap');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByTakeProfitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'takeProfitPrice');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalVolume');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByVolumeImbalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volumeImbalance');
    });
  }

  QueryBuilder<Trade, Trade, QDistinct> distinctByWasRuleBroken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasRuleBroken');
    });
  }
}

extension TradeQueryProperty on QueryBuilder<Trade, Trade, QQueryProperty> {
  QueryBuilder<Trade, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Trade, List<String>?, QQueryOperations>
      afterExitScreenshotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'afterExitScreenshots');
    });
  }

  QueryBuilder<Trade, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<Trade, List<String>?, QQueryOperations>
      beforeEntryScreenshotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beforeEntryScreenshots');
    });
  }

  QueryBuilder<Trade, String?, QQueryOperations> brokenRuleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'brokenRule');
    });
  }

  QueryBuilder<Trade, double, QQueryOperations> commissionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commission');
    });
  }

  QueryBuilder<Trade, int?, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> cvdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cvd');
    });
  }

  QueryBuilder<Trade, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Trade, TradeDirection, QQueryOperations> directionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'direction');
    });
  }

  QueryBuilder<Trade, int?, QQueryOperations> durationHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationHours');
    });
  }

  QueryBuilder<Trade, int?, QQueryOperations> durationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMinutes');
    });
  }

  QueryBuilder<Trade, String?, QQueryOperations> emotionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotion');
    });
  }

  QueryBuilder<Trade, double, QQueryOperations> entryPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryPrice');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> exitPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exitPrice');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> highPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highPrice');
    });
  }

  QueryBuilder<Trade, bool, QQueryOperations> isLongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLong');
    });
  }

  QueryBuilder<Trade, double, QQueryOperations> leverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leverage');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> lowPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowPrice');
    });
  }

  QueryBuilder<Trade, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Trade, String, QQueryOperations> pairProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pair');
    });
  }

  QueryBuilder<Trade, double, QQueryOperations> pnlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pnl');
    });
  }

  QueryBuilder<Trade, double, QQueryOperations> pnlPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pnlPercentage');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> riskRewardRatioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'riskRewardRatio');
    });
  }

  QueryBuilder<Trade, String?, QQueryOperations> sessionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'session');
    });
  }

  QueryBuilder<Trade, TradeStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> stopLossPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stopLossPrice');
    });
  }

  QueryBuilder<Trade, String?, QQueryOperations> strategyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strategy');
    });
  }

  QueryBuilder<Trade, double, QQueryOperations> swapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'swap');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> takeProfitPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'takeProfitPrice');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> totalVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalVolume');
    });
  }

  QueryBuilder<Trade, double?, QQueryOperations> volumeImbalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volumeImbalance');
    });
  }

  QueryBuilder<Trade, bool, QQueryOperations> wasRuleBrokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasRuleBroken');
    });
  }
}
