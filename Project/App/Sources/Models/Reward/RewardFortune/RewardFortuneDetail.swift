//
//  RewardFortuneDetail.swift
//  Flifin
//
//  Created by hyerin on 1/9/26.
//

import SwiftUI

struct RewardFortuneDetail: Equatable {
  let title: String
  let scoreInfo: FortuneScore
  let cardInfo: FortuneCard
  let overallFortune: OverallFortune
  let categoryFortuneItems: [CategoryFortuneItem]
  let elementBalance: ElementBalance
  let elementShift: ElementShift
  let tipInfos: [Tip]
  
  init(
    title: String,
    scoreInfo: FortuneScore,
    cardInfo: FortuneCard,
    overallFortune: OverallFortune,
    categoryFortuneItems: [CategoryFortuneItem],
    elementBalance: ElementBalance,
    elementShift: ElementShift,
    tipInfos: [Tip]
  ) {
    self.title = title
    self.scoreInfo = scoreInfo
    self.cardInfo = cardInfo
    self.overallFortune = overallFortune
    self.categoryFortuneItems = categoryFortuneItems
    self.elementBalance = elementBalance
    self.elementShift = elementShift
    self.tipInfos = tipInfos
  }
}

extension RewardFortuneDetail {
  struct FortuneScore: Equatable {
    var fortuneTitle: String
    let scoreString: String
    let score: Int
    let summary: String
  }

  struct FortuneCard: Equatable {
    let backgroundImageURL: URL?
    let title: String
    let fortune: String
  }
  
  struct OverallFortune: Equatable {
    let title: String
    let fortune: String
  }
  
  struct CategoryFortuneItem: Equatable, Identifiable {
    var id: String { title }
    let imageURL: URL?
    let title: String
    let description: String
    
    init(
      imageURL: URL?,
      title: String,
      description: String
    ) {
      self.imageURL = imageURL
      self.title = title
      self.description = description
    }
  }
  
  struct ElementBalance: Equatable {
    let description: ElementBalanceDescription
    let balanceItem: [ElementBalanceItem]
    
    init(description: ElementBalanceDescription, balanceItem: [ElementBalanceItem]) {
      self.description = description
      self.balanceItem = balanceItem
    }
    
    struct ElementBalanceDescription: Equatable {
      let description: String
      let highlight: String
      let color: Color
    }
    
    struct ElementBalanceItem: Equatable, Identifiable {
      var id: String { element }
      let element: String
      let percentage: Double
      let color: Color
      let imageURL: URL?
    }
  }
  
  struct ElementShift: Equatable {
    let title: String
    let description: String
  }
  
  struct Tip: Equatable, Identifiable {
    var id: String { content }
    let imageURL: URL?
    let title: String
    let content: String
    let contentColor: Color?
  }
}

extension RewardFortuneDetail {
  static func sample(date: String) -> RewardFortuneDetail {
    RewardFortuneDetail(
      title: "리워드는 뭔가요?",
      scoreInfo: .init(
        fortuneTitle: date,
        scoreString: "79점 (예시데이터)",
        score: 79,
        summary: "올 한해는 전반적으로 마음이 들뜨는 날이에요,\n한템포 쉬어가요."
      ),
      cardInfo: .init(
        backgroundImageURL: URL.urlForResource(.fortuneCardFrontDefaultView),
        title: "최고의 날",
        fortune: "네잎클로버"
      ),
      overallFortune: .init(
        title: "전반적인 운세 타이틀",
        fortune: "오늘은 지갑을 더 단단히 쥐고 계셔야겠어요. 괜히 시선 가는 거 많고, 충동구매가 살짝 걱정되는 날이에요. 꼭 필요한 소비인지 한 번만 더 생각해보면, 내일의 나에게 분명 고마워할 거예요. 행운의 색인 연두색이 들어간 소품을 곁에 두면 조금 더 차분한 하루가 될지도 몰라요."
      ),
      categoryFortuneItems: [
        CategoryFortuneItem(
          imageURL: URL.urlForResource(.money),
          title: "금전운",
          description: "현재의 상황을 최우선적으로 고려해보는 것이 좋아요. 과거의 상황까지 고려할 필요는 없어요."
        ),
        CategoryFortuneItem(
          imageURL: URL.urlForResource(.love),
          title: "연애운",
          description: "상대방의 말보다 분위기를 읽는 게 관계에 좋은 영향이 있어요."
        ),
        CategoryFortuneItem(
          imageURL: URL.urlForResource(.study),
          title: "학업운",
          description: "현재의 상황을 최우선적으로 고려해보는 것이 좋아요. 과거의 상황까지 고려할 필요는 없어요."
        )
      ],
      elementBalance: .init(
        description: .init(
          description: "내년엔 화기운이 너무 강해져요!\n화기운을 조심해야 해요~",
          highlight: "화기운",
          color: .red
        ),
        balanceItem: [
          .init(
            element: "적정",
            percentage: 0.2,
            color: ColorResource.Green._100.color,
            imageURL: URL.urlForResource(.tree)
          ),
          .init(
            element: "과다",
            percentage: 0.4,
            color: ColorResource.Red._100.color,
            imageURL: URL.urlForResource(.fire)
          ),
          .init(
            element: "적정",
            percentage: 0.3,
            color: ColorResource.Green._100.color,
            imageURL: URL.urlForResource(.soil)
          ),
          .init(
            element: "적정",
            percentage: 0.2,
            color: ColorResource.Green._100.color,
            imageURL: URL.urlForResource(.gold)
          ),
          .init(
            element: "부족",
            percentage: 0.1,
            color: ColorResource.Violet._500.color,
            imageURL: URL.urlForResource(.water)
          )
        ]
      ),
      elementShift: .init(
        title: "올해의 기운 변화 타이틀",
        description: """
        화의 기운은
        ‘결단력・집중・주체성’을 밝히는 에너지예요.
        불안이나 충동으로 흐르면 지치기 쉽지만,
        올바르게 쓰이면 원하는 방향으로 크게 나아가는 달이 됩니다.

        그래서 이번 달엔…
        ∙ 지금의 상황을 기준으로 결정해보세요.
        ∙ 감정보다는 리듬을 안정시키면 잘 흘러가요.
        ∙ 내일의 나에게 분명 고마운 선택을 하게 될 거예요.
        """
      ),
      tipInfos: [
        .init(
          imageURL: .urlForResource(.knife),
          title: "오늘의 추천메뉴",
          content: "카레",
          contentColor: nil
        ),
        .init(
          imageURL: .urlForResource(.clover),
          title: "행운의 색상",
          content: "연두색",
          contentColor: ColorResource._23_B_169.color
        ),
        .init(
          imageURL: .urlForResource(.greenFace),
          title: "피해야 할 음식",
          content: "치킨, 닭",
          contentColor: nil
        ),
        .init(
          imageURL: .urlForResource(.redFace),
          title: "피해야 할 색상",
          content: "흰색",
          contentColor: ColorResource.Text.main.color
        )
      ]
    )
  }
}
