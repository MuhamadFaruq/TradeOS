// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'economic_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEconomicEventCollection on Isar {
  IsarCollection<EconomicEvent> get economicEvents => this.collection();
}

const EconomicEventSchema = CollectionSchema(
  name: r'EconomicEvent',
  id: -8876428411995578564,
  properties: {
    r'actual': PropertySchema(
      id: 0,
      name: r'actual',
      type: IsarType.string,
    ),
    r'country': PropertySchema(
      id: 1,
      name: r'country',
      type: IsarType.string,
    ),
    r'currency': PropertySchema(
      id: 2,
      name: r'currency',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'forecast': PropertySchema(
      id: 4,
      name: r'forecast',
      type: IsarType.string,
    ),
    r'impact': PropertySchema(
      id: 5,
      name: r'impact',
      type: IsarType.byte,
      enumMap: _EconomicEventimpactEnumValueMap,
    ),
    r'isNotified': PropertySchema(
      id: 6,
      name: r'isNotified',
      type: IsarType.bool,
    ),
    r'previous': PropertySchema(
      id: 7,
      name: r'previous',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 8,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _economicEventEstimateSize,
  serialize: _economicEventSerialize,
  deserialize: _economicEventDeserialize,
  deserializeProp: _economicEventDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _economicEventGetId,
  getLinks: _economicEventGetLinks,
  attach: _economicEventAttach,
  version: '3.1.0+1',
);

int _economicEventEstimateSize(
  EconomicEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actual;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.country.length * 3;
  bytesCount += 3 + object.currency.length * 3;
  {
    final value = object.forecast;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.previous;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _economicEventSerialize(
  EconomicEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actual);
  writer.writeString(offsets[1], object.country);
  writer.writeString(offsets[2], object.currency);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeString(offsets[4], object.forecast);
  writer.writeByte(offsets[5], object.impact.index);
  writer.writeBool(offsets[6], object.isNotified);
  writer.writeString(offsets[7], object.previous);
  writer.writeString(offsets[8], object.title);
}

EconomicEvent _economicEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EconomicEvent();
  object.actual = reader.readStringOrNull(offsets[0]);
  object.country = reader.readString(offsets[1]);
  object.currency = reader.readString(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.forecast = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.impact =
      _EconomicEventimpactValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          Impact.low;
  object.isNotified = reader.readBool(offsets[6]);
  object.previous = reader.readStringOrNull(offsets[7]);
  object.title = reader.readString(offsets[8]);
  return object;
}

P _economicEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (_EconomicEventimpactValueEnumMap[reader.readByteOrNull(offset)] ??
          Impact.low) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _EconomicEventimpactEnumValueMap = {
  'low': 0,
  'medium': 1,
  'high': 2,
};
const _EconomicEventimpactValueEnumMap = {
  0: Impact.low,
  1: Impact.medium,
  2: Impact.high,
};

Id _economicEventGetId(EconomicEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _economicEventGetLinks(EconomicEvent object) {
  return [];
}

void _economicEventAttach(
    IsarCollection<dynamic> col, Id id, EconomicEvent object) {
  object.id = id;
}

extension EconomicEventQueryWhereSort
    on QueryBuilder<EconomicEvent, EconomicEvent, QWhere> {
  QueryBuilder<EconomicEvent, EconomicEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EconomicEventQueryWhere
    on QueryBuilder<EconomicEvent, EconomicEvent, QWhereClause> {
  QueryBuilder<EconomicEvent, EconomicEvent, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterWhereClause> idBetween(
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
}

extension EconomicEventQueryFilter
    on QueryBuilder<EconomicEvent, EconomicEvent, QFilterCondition> {
  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actual',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actual',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actual',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actual',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actual',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actual',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actual',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actual',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actual',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actual',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actual',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      actualIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actual',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'country',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'country',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      countryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      dateGreaterThan(
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

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      dateLessThan(
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

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'forecast',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'forecast',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forecast',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forecast',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forecast',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forecast',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'forecast',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'forecast',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'forecast',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'forecast',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forecast',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      forecastIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'forecast',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition> idBetween(
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

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      impactEqualTo(Impact value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'impact',
        value: value,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      impactGreaterThan(
    Impact value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'impact',
        value: value,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      impactLessThan(
    Impact value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'impact',
        value: value,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      impactBetween(
    Impact lower,
    Impact upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'impact',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      isNotifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isNotified',
        value: value,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previous',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previous',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previous',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'previous',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previous',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      previousIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'previous',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension EconomicEventQueryObject
    on QueryBuilder<EconomicEvent, EconomicEvent, QFilterCondition> {}

extension EconomicEventQueryLinks
    on QueryBuilder<EconomicEvent, EconomicEvent, QFilterCondition> {}

extension EconomicEventQuerySortBy
    on QueryBuilder<EconomicEvent, EconomicEvent, QSortBy> {
  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByActual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actual', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByActualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actual', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByForecast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      sortByForecastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByImpact() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impact', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByImpactDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impact', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByIsNotified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotified', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      sortByIsNotifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotified', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByPrevious() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previous', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      sortByPreviousDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previous', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension EconomicEventQuerySortThenBy
    on QueryBuilder<EconomicEvent, EconomicEvent, QSortThenBy> {
  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByActual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actual', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByActualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actual', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByForecast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      thenByForecastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByImpact() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impact', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByImpactDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impact', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByIsNotified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotified', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      thenByIsNotifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotified', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByPrevious() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previous', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy>
      thenByPreviousDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previous', Sort.desc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension EconomicEventQueryWhereDistinct
    on QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> {
  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByActual(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actual', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByCountry(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'country', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByForecast(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forecast', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByImpact() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'impact');
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByIsNotified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isNotified');
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByPrevious(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previous', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EconomicEvent, EconomicEvent, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension EconomicEventQueryProperty
    on QueryBuilder<EconomicEvent, EconomicEvent, QQueryProperty> {
  QueryBuilder<EconomicEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EconomicEvent, String?, QQueryOperations> actualProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actual');
    });
  }

  QueryBuilder<EconomicEvent, String, QQueryOperations> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'country');
    });
  }

  QueryBuilder<EconomicEvent, String, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<EconomicEvent, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<EconomicEvent, String?, QQueryOperations> forecastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forecast');
    });
  }

  QueryBuilder<EconomicEvent, Impact, QQueryOperations> impactProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'impact');
    });
  }

  QueryBuilder<EconomicEvent, bool, QQueryOperations> isNotifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isNotified');
    });
  }

  QueryBuilder<EconomicEvent, String?, QQueryOperations> previousProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previous');
    });
  }

  QueryBuilder<EconomicEvent, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
