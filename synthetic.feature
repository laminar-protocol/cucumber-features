Feature: Synthetic Protocol

  Scenario: Synthetic liquidity pool
    Given accounts
      | Name  | Amount  |
      | Pool  | $10 000 |
      | Alice | $10 000 |
    And synthetic create liquidity pool
    And synthetic deposit liquidity
      | Name  | Amount  | Result        |
      | Pool  | $10 000 | Ok            |
      | Alice | $5 000  | Ok            |
      | Alice | $6 000  | BalanceTooLow |
    Then synthetic liquidity is $15000

  Scenario: Synthetic buy and sell
    Given accounts
      | Name  | Amount  |
      | Pool  | $10 000 |
      | Alice | $10 000 |
    And synthetic create liquidity pool
    And synthetic deposit liquidity
      | Name  | Amount  | Result        |
      | Pool  | $10 000 | Ok            |
    And synthetic set min additional collateral ratio to 10%
    And synthetic set additional collateral ratio
      | Currency | Ratio |
      | FEUR     | 10%   |
    And synthetic set spread
      | Currency | Ratio |
      | FEUR     | $0.03 |
    And oracle price
      | Currency  | Price  |
      | FEUR      | $3     |
    When synthetic buy
      | Name  | Currency | Amount |
      | Alice | FEUR     | $5000  |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic              |
      | Alice | $5000 | FEUR      | 1650165016501650165016 |
    Then synthetic liquidity is 9554455445544554455447
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1100000000000000000 | true    |
    Then synthetic module balance is 5445544554455445544553
    When synthetic sell
      | Name  | Currency | Amount |
      | Alice | FEUR     | $800   |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic             |
      | Alice | $7376 | FEUR      | 850165016501650165016 |
    Then synthetic liquidity is 9818455445544554455447
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1100000000000000000 | true    |

  Scenario: Synthetic trader take profit
    Given accounts
      | Name  | Amount  |
      | Pool  | $10 000 |
      | Alice | $10 000 |
    And synthetic create liquidity pool
    And synthetic deposit liquidity
      | Name  | Amount  | Result        |
      | Pool  | $10 000 | Ok            |
    And synthetic set min additional collateral ratio to 10%
    And synthetic set additional collateral ratio
      | Currency | Ratio |
      | FEUR     | 10%   |
    And synthetic set spread
      | Currency | Ratio |
      | FEUR     | $0.03 |
    And oracle price
      | Currency  | Price  |
      | FEUR      | $3     |
    When synthetic buy
      | Name  | Currency | Amount |
      | Alice | FEUR     | $5000  |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic              |
      | Alice | $5000 | FEUR      | 1650165016501650165016 |
    Then synthetic liquidity is 9554455445544554455447
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1100000000000000000 | true    |
    Then synthetic module balance is 5445544554455445544553
    And oracle price
      | Currency  | Price  |
      | FEUR      | $3.1   |
    When synthetic sell
      | Name  | Currency | Amount                 |
      | Alice | FEUR     | 1650165016501650165016 |
    Then synthetic balances are
      | Name  | Free                    | Currency  | Synthetic |
      | Alice | 10066006600660066006599 | FEUR      | 0         |
    Then synthetic module balance is 0
    Then synthetic liquidity is 9933993399339933993401
    Then synthetic pool info are
      | Currency  | Collateral Ratio | Is Safe |
      | FEUR      | 0                | false   |

  Scenario: Synthetic trader stop lost
    Given accounts
      | Name  | Amount  |
      | Pool  | $10 000 |
      | Alice | $10 000 |
    And synthetic create liquidity pool
    And synthetic deposit liquidity
      | Name  | Amount  | Result        |
      | Pool  | $10 000 | Ok            |
    And synthetic set min additional collateral ratio to 10%
    And synthetic set additional collateral ratio
      | Currency | Ratio |
      | FEUR     | 10%   |
    And synthetic set spread
      | Currency | Ratio |
      | FEUR     | $0.03 |
    And oracle price
      | Currency  | Price  |
      | FEUR      | $3     |
    When synthetic buy
      | Name  | Currency | Amount |
      | Alice | FEUR     | $5000  |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic              |
      | Alice | $5000 | FEUR      | 1650165016501650165016 |
    Then synthetic liquidity is 9554455445544554455447
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1100000000000000000 | true    |
    Then synthetic module balance is 5445544554455445544553
    And oracle price
      | Currency  | Price |
      | FEUR      | $2    |
    When synthetic sell
      | Name  | Currency | Amount                 |
      | Alice | FEUR     | 1650165016501650165016 |
    Then synthetic balances are
      | Name  | Free                   | Currency  | Synthetic |
      | Alice | 8250825082508250825081 | FEUR      | 0         |
    Then synthetic module balance is 0
    Then synthetic liquidity is 11749174917491749174919
    Then synthetic pool info are
      | Currency  | Collateral Ratio | Is Safe |
      | FEUR      | 0                | false   |

  Scenario: Synthetic multiple users multiple currencies
    Given accounts
      | Name  | Amount  |
      | Pool  | $40 000 |
      | Alice | $10 000 |
      | BOB   | $10 000 |
    And synthetic create liquidity pool
    And synthetic deposit liquidity
      | Name  | Amount  | Result        |
      | Pool  | $40 000 | Ok            |
    And synthetic set min additional collateral ratio to 10%
    And synthetic set additional collateral ratio
      | Currency | Ratio |
      | FEUR     | 10%   |
    And synthetic set spread
      | Currency | Ratio |
      | FEUR     | $0.03 |
      | FJPY     | $0.04 |
    And oracle price
      | Currency  | Price  |
      | FEUR      | $3     |
      | FJPY      | $4     |
    When synthetic buy
      | Name  | Currency | Amount |
      | Alice | FEUR     | $5000  |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic              |
      | Alice | $5000 | FEUR      | 1650165016501650165016 |
    Then synthetic liquidity is 39554455445544554455447
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1100000000000000000 | true    |
      | FJPY      | 0                   | false   |
    Then synthetic module balance is 5445544554455445544553
    When synthetic buy
      | Name  | Currency | Amount |
      | BOB   | FJPY     | $5000  |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic              |
      | BOB   | $5000 | FJPY      | 1237623762376237623762 |
    Then synthetic liquidity is 39108910891089108910894
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1100000000000000000 | true    |
      | FJPY      | 1100000000000000000 | true    |
    Then synthetic module balance is 10891089108910891089106
    And oracle price
      | Currency  | Price |
      | FEUR      | $2    |
      | FJPY      | $5    |
    When synthetic buy
      | Name  | Currency | Amount |
      | Alice | FJPY     | $2000  |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic             |
      | Alice | $3000 | FJPY      | 396825396825396825396 |
    Then synthetic liquidity is 38926371208549426371216
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1650000000000000000 | true    |
      | FJPY      | 933413461538461538  | false   |
    Then synthetic module balance is 13073628791450573628784
    When synthetic buy
      | Name  | Currency | Amount |
      | BOB   | FEUR     | $2000  |
    Then synthetic balances are
      | Name  | Free  | Currency  | Synthetic             |
      | BOB   | $3000 | FEUR      | 985221674876847290640 |
    Then synthetic module balance is 15241116476179637668192
    Then synthetic liquidity is 38758883523820362331808
    Then synthetic pool info are
      | Currency | Collateral Ratio    | Is Safe |
      | FEUR     | 1444386181369524984 | true    |
      | FJPY     | 933413461538461538  | false   |
    When synthetic sell
      | Name  | Currency | Amount |
      | Alice | FEUR     | $100  |
    Then synthetic balances are
      | Name  | Free                   | Currency  | Synthetic              |
      | Alice | 3197000000000000000000 | FEUR      | 1550165016501650165016 |
    Then synthetic module balance is 13205934958027822486674
    Then synthetic liquidity is 40597065041972177513326
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1099999999999999999 | true    |
      | FJPY      | 933413461538461538  | false   |
    When synthetic sell
      | Name  | Currency | Amount |
      | BOB   | FJPY     | $100  |
    Then synthetic balances are
      | Name  | Free                   | Currency  | Synthetic              |
      | BOB   | 3496000000000000000000 | FJPY      | 1137623762376237623762 |
    Then synthetic module balance is 12709934958027822486674
    Then synthetic liquidity is 40597065041972177513326
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1099999999999999999 | true    |
      | FJPY      | 929595378801069266  | false |
    When synthetic sell
      | Name  | Currency | Amount |
      | Alice | FJPY     | $100  |
    Then synthetic balances are
      | Name  | Free                   | Currency  | Synthetic             |
      | Alice | 3693000000000000000000 | FJPY      | 296825396825396825396 |
    Then synthetic module balance is 12213934958027822486674
    Then synthetic liquidity is 40597065041972177513326
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1099999999999999999 | true    |
      | FJPY      | 925244954751626969  | false   |
    When synthetic sell
      | Name  | Currency | Amount |
      | BOB   | FEUR     | $100  |
    Then synthetic balances are
      | Name  | Free                   | Currency  | Synthetic             |
      | BOB   | 3693000000000000000000 | FEUR      | 885221674876847290640 |
    Then synthetic module balance is 11993934958027822486674
    Then synthetic liquidity is 40620065041972177513326
    Then synthetic pool info are
      | Currency  | Collateral Ratio    | Is Safe |
      | FEUR      | 1099999999999999999 | true    |
      | FJPY      | 925244954751626969  | false   |
